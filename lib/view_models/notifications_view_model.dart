import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mstra/routes/routes_manager.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    // Request permission on iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Initialize local notifications for foreground notifications
      _initializeLocalNotifications();

      // Subscribe all users to the 'general_updates' topic
      await _subscribeToTopic('general_updates');

      // For handling foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          // If it has notification payload, treat it as a notification
          print(
              'Foreground notification received: ${message.notification?.title}');
          _showLocalNotification(message);
        } else if (message.data.isNotEmpty) {
          // If it only has data payload, treat it as a data message
          print('Foreground data message received: ${message.data}');
          _handleDataMessage(context, message);
        }
      });

      // For handling background messages
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle when the app is opened from a notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.notification != null) {
          print(
              'Notification clicked (App in background): ${message.notification?.title}');
          _handleNotificationNavigation(context, message);
        } else if (message.data.isNotEmpty) {
          print('Data message clicked (App in background): ${message.data}');
          _handleDataMessage(context, message);
        }
      });

      // Token management
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');
      // Send this token to your server to target this device
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Initialize local notifications
  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Subscribe to a topic
  Future<void> _subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to $topic topic');
  }

  // Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel Name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformChannelSpecifics,
      payload: message.data['route'], // Custom payload data
    );
  }

  // Handle navigation when a notification is tapped
  void _handleNotificationNavigation(
      BuildContext context, RemoteMessage message) {
    // Implement your navigation based on notification data
    String? route = message.data['route'];
    if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      // Navigate to a default page
      Navigator.pushNamed(context, RoutesManager.homePage);
    }
  }

  // Handle data message
  void _handleDataMessage(BuildContext context, RemoteMessage message) {
    // Example of custom logic for handling data messages
    print('Handling data message: ${message.data}');
    String? type = message.data['type'];
    String? route = message.data['route'];

    if (type == 'in_app_message') {
      _showInAppMessage(context, message.data['title'] ?? 'No Title',
          message.data['message'] ?? 'No Message', route);
    }
  }

  // Display an in-app message (for data messages)
  void _showInAppMessage(
      BuildContext context, String title, String message, String? route) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle route navigation if provided
                if (route != null) {
                  Navigator.pushNamed(context, route);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    // Handle background notifications
  }

  // To handle when the app is launched from a terminated state
  Future<void> checkForInitialMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(
          'App launched from notification: ${initialMessage.notification?.title}');
      if (initialMessage.notification != null) {
        _handleNotificationNavigation(context, initialMessage);
      } else if (initialMessage.data.isNotEmpty) {
        _handleDataMessage(context, initialMessage);
      }
    }
  }
}

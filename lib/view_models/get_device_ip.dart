import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String?> getAndroidDeviceId() async {
  try {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // The updated property name for Android device ID
    } else {
      return "Not an Android device";
    }
  } catch (e) {
    print("Failed to get Android Device ID: $e");
    return null;
  }
}

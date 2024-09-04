import 'package:flutter/material.dart';
import 'package:mstra/models/pdf_model.dart';
import 'package:mstra/models/record_model.dart';
import 'package:mstra/res/app_url.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/course_model.dart';
import '../models/video_model.dart'; // Make sure to import your VideoModel

class CourseDetailViewModel extends ChangeNotifier {
  CourseModel? _course;
  VideoModel? _video;
  PdfModel? _pdf; // Add a video model variable
  bool _isLoading = false;
  String _error = '';
  bool _videoIframe = false;
  RecordModel? _record;

  bool get videoIframe => _videoIframe;
  PdfModel? get pdf => _pdf;
  CourseModel? get course => _course;
  VideoModel? get video => _video; // Add getter for video
  bool get isLoading => _isLoading;
  String get error => _error;
  RecordModel? get record => _record;

  Future<void> fetchCourseBySlug(String slug) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      String url;
      if (accessToken != null) {
        url = '${AppUrl.authenticatedSingleCourseEndPoint}/$slug';
      } else {
        url = '${AppUrl.publicSinglecoursesEndPoint}/$slug';
      }
      print('Request URL: $url');
      final headers = {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };
      print('Access Token: $accessToken');
      print('Request Headers: $headers');
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        final data = json.decode(response.body);
        _course = CourseModel.fromJson(data);
        _error = '';
      } else {
        _error = 'Failed to load course. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSingleVideo(
      int videoId, int courseId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      String urlVid;

      if (course != null && accessToken != null) {
        urlVid = '${AppUrl.baseUrl}/courses/$courseId/videos/$videoId';
      } else {
        _error = 'Course data is not loaded or invalid.';
        _isLoading = false;
        notifyListeners();
        if (ScaffoldMessenger.maybeOf(context) != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
        return; // Exit the method early if course is not valid
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(Uri.parse(urlVid), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _video = VideoModel.fromJson(data);
        print(
            "${_video!.url}=================================================");

        _error = '';

        // Check if video URL is loaded correctly
        if (_video!.url == null) {
          _error = 'Failed to load video URL. Please try again.';
          if (ScaffoldMessenger.maybeOf(context) != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_error)),
            );
          }
        } else {
          // Save the video URL to SharedPreferences
          await prefs.setString('video_url', _video!.url!);
          print('Video URL saved in SharedPreferences: ${_video!.url}');
        }
      } else {
        _error = 'Failed to load video. Status Code: ${response.statusCode}';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
      }
    } catch (e) {
      _error = 'Error: $e';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error)),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //fetch single Record
  Future<void> fetchSingleRecord(
      int recordId, int courseId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      String urlRec;

      if (course != null && accessToken != null) {
        urlRec = '${AppUrl.baseUrl}/courses/$courseId/records/$recordId';
      } else {
        _error = 'Course data is not loaded or invalid.';
        _isLoading = false;
        notifyListeners();
        if (ScaffoldMessenger.maybeOf(context) != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
        return; // Exit the method early if course is not valid
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(Uri.parse(urlRec), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _record = RecordModel.fromJson(data);
        print(
            "${_record!.url}=================================================");

        _error = '';

        // Check if video URL is loaded correctly
        if (_record!.url == null) {
          _error = 'Failed to load record URL. Please try again.';
          if (ScaffoldMessenger.maybeOf(context) != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_error)),
            );
          }
        } else {
          // Save the video URL to SharedPreferences
          // await prefs.setString('video_url', _!.url!);
          print('Record URL saved in SharedPreferences: ${_record!.url}');
        }
      } else {
        _error = 'Failed to load Rec. Status Code: ${response.statusCode}';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
      }
    } catch (e) {
      _error = 'Error: $e';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error)),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSinglePdf(
      int pdfId, int courseId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      String urlPdf;

      if (course != null && accessToken != null) {
        urlPdf = '${AppUrl.baseUrl}/courses/$courseId/pdfs/$pdfId';
      } else {
        _error = 'Course data is not loaded or invalid.';
        _isLoading = false;
        notifyListeners();
        if (ScaffoldMessenger.maybeOf(context) != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
        return; // Exit the method early if course is not valid
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(Uri.parse(urlPdf), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _pdf = PdfModel.fromJson(data);
        print("${_pdf!.url}=================================================");

        _error = '';

        // Check if pdf URL is loaded correctly
        if (_pdf!.url == null) {
          _error = 'Failed to load pdf URL. Please try again.';
          if (ScaffoldMessenger.maybeOf(context) != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_error)),
            );
          }
        } else {
          // Save the video URL to SharedPreferences
          // await prefs.setString('video_url', _!.url!);
          print('Pdf URL : ${_pdf!.url}');
        }
      } else {
        _error = 'Failed to load Rec. Status Code: ${response.statusCode}';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error)),
          );
        }
      }
    } catch (e) {
      _error = 'Error: $e';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error)),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setVideoIframe(bool value) {
    _videoIframe = value;
    notifyListeners();
  }
}

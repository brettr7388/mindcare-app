import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../config/api_config.dart';
import '../main.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _profilePictureUrl;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get profilePictureUrl => _profilePictureUrl;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please check your internet connection and try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _userName = data['name'];
        _userEmail = data['email'];
        _profilePictureUrl = data['profilePicture'] != null 
            ? '${ApiConfig.baseUrl}/../${data['profilePicture']}'
            : null;
        _isAuthenticated = true;

        // Fetch moods after successful login
        if (navigatorKey.currentContext != null) {
          final moodProvider = Provider.of<MoodProvider>(navigatorKey.currentContext!, listen: false);
          await moodProvider.fetchMoods();
        }

        notifyListeners();
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Login failed. Please check your credentials and try again.');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet connection and try again.');
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw Exception('Could not connect to the server. Please check your internet connection and try again.');
      }
      throw Exception('Error during login: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        _userName = data['name'];
        _userEmail = data['email'];
        _profilePictureUrl = data['profilePicture'] != null 
            ? '${ApiConfig.baseUrl}/../${data['profilePicture']}'
            : null;
        _isAuthenticated = true;
        
        notifyListeners();
      } else {
        throw Exception('Failed to signup');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userName = null;
    _userEmail = null;
    _profilePictureUrl = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'name': name,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please check your internet connection and try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userName = data['name'];
        _profilePictureUrl = data['profilePicture'] != null 
            ? '${ApiConfig.baseUrl}/../${data['profilePicture']}'
            : null;
        notifyListeners();
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to update profile');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet connection and try again.');
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw Exception('Could not connect to the server. Please check your internet connection and try again.');
      }
      throw Exception('Error updating profile: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadProfilePicture(String imagePath) async {
    try {
      _isLoading = true;
      notifyListeners();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/auth/profile/upload-picture'),
      );

      request.headers['Authorization'] = 'Bearer $_token';
      request.files.add(await http.MultipartFile.fromPath('profilePicture', imagePath));

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Upload timed out. Please check your internet connection and try again.');
        },
      );

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        _profilePictureUrl = data['profilePicture'] != null 
            ? '${ApiConfig.baseUrl}/../${data['profilePicture']}'
            : null;
        notifyListeners();
      } else {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        throw Exception(data['message'] ?? 'Failed to upload profile picture');
      }
    } on TimeoutException {
      throw Exception('Upload timed out. Please check your internet connection and try again.');
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw Exception('Could not connect to the server. Please check your internet connection and try again.');
      }
      throw Exception('Error uploading profile picture: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfilePicture() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/auth/profile/picture'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please check your internet connection and try again.');
        },
      );

      if (response.statusCode == 200) {
        _profilePictureUrl = null;
        notifyListeners();
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to delete profile picture');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please check your internet connection and try again.');
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw Exception('Could not connect to the server. Please check your internet connection and try again.');
      }
      throw Exception('Error deleting profile picture: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    // Always start with no authentication - no persistence
    _token = null;
    _userName = null;
    _userEmail = null;
    _profilePictureUrl = null;
    _isAuthenticated = false;
    notifyListeners();
  }
} 
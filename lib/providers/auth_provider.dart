import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../main.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.132.188.218:3000/api';
  bool _isAuthenticated = false;
  String? _token;
  String? _userId;
  String? _userName;
  String? _userEmail;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
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
        _userId = data['userId'];
        _userName = data['name'];
        _userEmail = data['email'];
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
        Uri.parse('$_baseUrl/auth/signup'),
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
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    // Always start with no authentication - no persistence
    _token = null;
    _userName = null;
    _userEmail = null;
    _isAuthenticated = false;
    notifyListeners();
  }
} 
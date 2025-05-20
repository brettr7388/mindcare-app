import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../main.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'http://192.168.86.212:3000/api';
  final _storage = const FlutterSecureStorage();
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
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _userId = data['userId'];
        _userName = data['name'];
        _userEmail = data['email'];

        // Store user data in secure storage
        await _storage.write(key: 'token', value: _token);
        await _storage.write(key: 'userId', value: _userId);
        await _storage.write(key: 'userName', value: _userName);
        await _storage.write(key: 'userEmail', value: _userEmail);

        // Fetch moods after successful login
        if (navigatorKey.currentContext != null) {
          final moodProvider = Provider.of<MoodProvider>(navigatorKey.currentContext!, listen: false);
          await moodProvider.fetchMoods();
        }

        notifyListeners();
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
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
        
        await _storage.write(key: 'token', value: _token);
        await _storage.write(key: 'userName', value: _userName);
        await _storage.write(key: 'userEmail', value: _userEmail);
        
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
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _token = await _storage.read(key: 'token');
    _userName = await _storage.read(key: 'userName');
    _userEmail = await _storage.read(key: 'userEmail');
    _isAuthenticated = _token != null;
    notifyListeners();
  }
} 
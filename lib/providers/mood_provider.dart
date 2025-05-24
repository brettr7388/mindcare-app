import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mood.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class MoodProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.132.188.218:3000/api';
  List<Mood> _moods = [];
  Mood? _todayMood;
  bool _isLoading = false;

  List<Mood> get moods => _moods;
  Mood? get todayMood => _todayMood;
  bool get isLoading => _isLoading;
  bool get hasMoodForToday => _todayMood != null;

  Future<void> fetchMoods() async {
    try {
      _isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/moods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _moods = data.map((json) => Mood.fromJson(json)).toList();
        
        // Update today's mood
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        try {
          _todayMood = _moods.firstWhere(
            (mood) {
              final moodDate = DateTime(mood.timestamp.year, mood.timestamp.month, mood.timestamp.day);
              return moodDate.isAtSameMomentAs(today);
            },
          );
        } catch (e) {
          _todayMood = null;
        }
        notifyListeners();
      } else {
        throw Exception('Failed to fetch moods');
      }
    } catch (e) {
      print('Error fetching moods: $e'); // Debug log
      throw Exception('Error fetching moods: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMood(int rating) async {
    try {
      _isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/moods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: json.encode({
          'rating': rating,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final newMood = Mood.fromJson(data);
        _moods.insert(0, newMood); // Insert at the beginning to maintain chronological order
        _todayMood = newMood;
        notifyListeners();
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Failed to add mood');
      } else {
        throw Exception('Failed to add mood');
      }
    } catch (e) {
      throw Exception('Error adding mood: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMood(String id, int rating) async {
    try {
      _isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/moods/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: json.encode({
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        final updatedMood = Mood.fromJson(json.decode(response.body));
        final index = _moods.indexWhere((m) => m.id == id);
        if (index != -1) {
          _moods[index] = updatedMood;
          if (_todayMood?.id == id) {
            _todayMood = updatedMood;
          }
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update mood');
      }
    } catch (e) {
      throw Exception('Error updating mood: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);
    final moodDate = date.toUtc();
    final moodDay = DateTime(moodDate.year, moodDate.month, moodDate.day);
    
    print('Comparing dates: $today and $moodDay'); // Debug log
    return today.isAtSameMomentAs(moodDay);
  }
} 
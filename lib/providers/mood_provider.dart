import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mood.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../main.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];
  List<Mood> get moods => _moods;

  Future<void> addMood(int rating, String note) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.86.212:3000/api/moods'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: json.encode({
          'rating': rating,
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final newMood = Mood(
          id: data['_id'],
          rating: rating,
          note: note,
          timestamp: DateTime.parse(data['createdAt']),
        );
        _moods.insert(0, newMood);
        notifyListeners();
      } else {
        throw Exception('Failed to add mood: ${response.body}');
      }
    } catch (e) {
      print('Error adding mood: $e');
      throw Exception('Failed to add mood: $e');
    }
  }

  Future<void> fetchMoods() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.86.212:3000/api/moods'),
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _moods = data.map((json) => Mood.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch moods: ${response.body}');
      }
    } catch (e) {
      print('Error fetching moods: $e');
      throw Exception('Failed to fetch moods: $e');
    }
  }

  Future<String> _getToken() async {
    // Get the token from your auth provider
    final authProvider = Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);
    return authProvider.token ?? '';
  }

  Future<void> updateMood(String id, int rating, String note) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.86.212:3000/api/moods/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: json.encode({
          'rating': rating,
          'note': note,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedMood = Mood(
          id: data['_id'],
          rating: rating,
          note: note,
          timestamp: DateTime.parse(data['createdAt']),
        );
        
        final index = _moods.indexWhere((mood) => mood.id == id);
        if (index != -1) {
          _moods[index] = updatedMood;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update mood: ${response.body}');
      }
    } catch (e) {
      print('Error updating mood: $e');
      throw Exception('Failed to update mood: $e');
    }
  }
} 
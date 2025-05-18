import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class Mood {
  final String id;
  final int rating;
  final String note;
  final DateTime timestamp;

  Mood({
    required this.id,
    required this.rating,
    required this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'note': note,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
    id: json['id'],
    rating: json['rating'],
    note: json['note'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];
  Box<Mood>? _moodBox;
  static const String _baseUrl = 'http://192.168.86.212:3000/api';

  List<Mood> get moods => _moods;

  Future<void> initHive() async {
    if (!Hive.isBoxOpen('moods')) {
      _moodBox = await Hive.openBox<Mood>('moods');
      _loadMoodsFromHive();
    }
  }

  void _loadMoodsFromHive() {
    if (_moodBox != null) {
      _moods = _moodBox!.values.toList();
      notifyListeners();
    }
  }

  Future<void> addMood(BuildContext context, int rating, String note) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final mood = Mood(
          id: data['_id'], // MongoDB uses _id
          rating: rating,
          note: note,
          timestamp: DateTime.parse(data['createdAt']),
        );
        
        _moods.add(mood);
        await _moodBox?.put(mood.id, mood);
        notifyListeners();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add mood');
      }
    } catch (e) {
      print('Error adding mood: $e'); // Debug print
      rethrow;
    }
  }

  Future<void> fetchMoods(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/moods'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _moods = data.map((json) => Mood(
          id: json['_id'],
          rating: json['rating'],
          note: json['note'] ?? '',
          timestamp: DateTime.parse(json['createdAt']),
        )).toList();
        
        await _moodBox?.clear();
        for (var mood in _moods) {
          await _moodBox?.put(mood.id, mood);
        }
        notifyListeners();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch moods');
      }
    } catch (e) {
      print('Error fetching moods: $e'); // Debug print
      rethrow;
    }
  }
} 
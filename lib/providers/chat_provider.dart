import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class Message {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    content: json['content'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  static const String _baseUrl = 'http://76.233.7.53:3000/api';

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(BuildContext context, String content) async {
    try {
      _isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }
      
      // Add user message to the list
      final userMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      );
      _messages.add(userMessage);
      notifyListeners();

      print('Sending message to: $_baseUrl/chat'); // Debug print
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: json.encode({
          'message': content,
        }),
      );

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiMessage = Message(
          id: data['id'],
          content: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(aiMessage);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      print('Chat error: $e'); // For debugging
      // Add error message
      _messages.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, there was an error processing your message. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
} 
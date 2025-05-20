import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;
  static const String _baseUrl = 'http://192.168.86.212:3000/api';

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  void addWelcomeMessage() {
    if (_messages.isEmpty) {
      _messages.add(Message(
        content: 'Hello! I\'m your AI chat bot. I\'m here to provide a safe space for you to express yourself. What would you like to chat about today?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    }
  }

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
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      );
      _messages.add(userMessage);
      notifyListeners();

      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: json.encode({
          'message': content,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiMessage = Message(
          content: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(aiMessage);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['details'] ?? errorData['message'] ?? 'Failed to send message';
        throw Exception(errorMessage);
      }
    } on TimeoutException {
      _messages.add(Message(
        content: 'Sorry, the request timed out. Please check your internet connection and try again.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      String errorMessage = 'Sorry, there was an error processing your message.';
      
      if (e.toString().contains('Not authenticated')) {
        errorMessage = 'Please log in again to continue chatting.';
      } else if (e.toString().contains('timed out')) {
        errorMessage = 'The request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('Error getting AI response')) {
        errorMessage = 'Sorry, I\'m having trouble responding right now. Please try again in a moment.';
      }
      
      _messages.add(Message(
        content: errorMessage,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearConversation(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.token == null) {
        throw Exception('Not authenticated');
      }

      // Clear conversation history on the server
      await http.post(
        Uri.parse('$_baseUrl/chat/clear'),
        headers: {
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      // Clear local messages
      _messages.clear();
      notifyListeners();
    } catch (e) {
      print('❌ Error clearing conversation: $e');
    }
  }
} 
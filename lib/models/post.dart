import 'package:flutter/material.dart';

class Post {
  final String id;
  final String content;
  final DateTime timestamp;
  final List<Reply> replies;
  final int heartCount;
  final bool isAnonymous;

  Post({
    required this.id,
    required this.content,
    required this.timestamp,
    this.replies = const [],
    this.heartCount = 0,
    this.isAnonymous = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'replies': replies.map((r) => r.toJson()).toList(),
    'heartCount': heartCount,
    'isAnonymous': isAnonymous,
  };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    replies: (json['replies'] as List?)
        ?.map((r) => Reply.fromJson(r))
        .toList() ?? [],
    heartCount: json['heartCount'] ?? 0,
    isAnonymous: json['isAnonymous'] ?? true,
  );
}

class Reply {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isAnonymous;

  Reply({
    required this.id,
    required this.content,
    required this.timestamp,
    this.isAnonymous = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isAnonymous': isAnonymous,
  };

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    id: json['id'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isAnonymous: json['isAnonymous'] ?? true,
  );
} 
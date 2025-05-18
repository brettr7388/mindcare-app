import 'package:flutter/material.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  void loadInitialPosts() {
    // Add some initial motivational posts
    _posts = [
      Post(
        id: '1',
        content: 'Remember that every small step forward is progress. Don\'t compare your journey to others - you\'re exactly where you need to be right now. 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        heartCount: 15,
        replies: [
          Reply(
            id: '1-1',
            content: 'This really helped me today. Thank you for the reminder!',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ],
      ),
      Post(
        id: '2',
        content: 'Feeling overwhelmed with work lately. Any tips on maintaining work-life balance?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        heartCount: 8,
        replies: [
          Reply(
            id: '2-1',
            content: 'Try setting clear boundaries and taking regular breaks. Remember to schedule time for yourself too!',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          Reply(
            id: '2-2',
            content: 'I found that planning my week ahead helps a lot. Also, don\'t feel guilty about taking time off!',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      Post(
        id: '3',
        content: 'Just completed my first 5K run! Never thought I could do it, but here I am. Remember, you\'re capable of more than you think! 🏃‍♂️',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        heartCount: 23,
        replies: [
          Reply(
            id: '3-1',
            content: 'Congratulations! This is so inspiring!',
            timestamp: DateTime.now().subtract(const Duration(hours: 7)),
          ),
        ],
      ),
    ];
    notifyListeners();
  }

  void addPost(String content) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  void addReply(String postId, String content) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      final newReply = Reply(
        id: '${postId}-${DateTime.now().millisecondsSinceEpoch}',
        content: content,
        timestamp: DateTime.now(),
      );
      _posts[postIndex] = Post(
        id: post.id,
        content: post.content,
        timestamp: post.timestamp,
        replies: [...post.replies, newReply],
        heartCount: post.heartCount,
      );
      notifyListeners();
    }
  }

  void toggleHeart(String postId) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = Post(
        id: post.id,
        content: post.content,
        timestamp: post.timestamp,
        replies: post.replies,
        heartCount: post.heartCount + 1,
      );
      notifyListeners();
    }
  }
} 
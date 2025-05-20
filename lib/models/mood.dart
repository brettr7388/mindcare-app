class Mood {
  final String id;
  final int rating;
  final DateTime timestamp;

  Mood({
    required this.id,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Mood.fromJson(Map<String, dynamic> json) {
    // Handle both createdAt and timestamp fields
    final timestamp = json['createdAt'] ?? json['timestamp'];
    return Mood(
      id: json['_id'],
      rating: json['rating'],
      timestamp: DateTime.parse(timestamp),
    );
  }
} 
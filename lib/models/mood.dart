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
    id: json['_id'],
    rating: json['rating'],
    note: json['note'] ?? '',
    timestamp: DateTime.parse(json['createdAt']),
  );
} 
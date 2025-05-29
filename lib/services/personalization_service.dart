import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/mood.dart';

class PersonalizationService {
  static const String _weatherApiKey = 'demo_key'; // Replace with actual API key
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  // Time-based greetings
  static String getTimeBasedGreeting(String? userName) {
    final hour = DateTime.now().hour;
    final name = userName ?? 'there';
    
    if (hour < 12) {
      return 'Good morning, $name! ☀️';
    } else if (hour < 17) {
      return 'Good afternoon, $name! 🌤️';
    } else {
      return 'Good evening, $name! 🌙';
    }
  }

  // Weather-aware greetings
  static Future<String> getWeatherAwareGreeting() async {
    try {
      final weather = await _getCurrentWeather();
      return _getWeatherMessage(weather);
    } catch (e) {
      return _getRandomDefaultMessage();
    }
  }

  // Mood-based responses
  static String getMoodBasedResponse(List<Mood> recentMoods) {
    if (recentMoods.isEmpty) {
      return "Let's start tracking your mood journey! 🌱";
    }

    final todayMood = recentMoods.first;
    final yesterday = recentMoods.length > 1 ? recentMoods[1] : null;

    if (yesterday != null) {
      if (todayMood.rating > yesterday.rating) {
        return "Feeling better today? That's wonderful to see! 📈✨";
      } else if (todayMood.rating < yesterday.rating) {
        return "Every day has its challenges. You're doing great! 💪";
      }
    }

    switch (todayMood.rating) {
      case 5:
        return "Your positive energy is contagious! Keep shining! ⭐";
      case 4:
        return "Great to see you feeling good today! 😊";
      case 3:
        return "Balance is key. You're doing just fine! ⚖️";
      case 2:
        return "It's okay to have difficult days. Be gentle with yourself 🤗";
      case 1:
        return "I'm here with you. Take things one step at a time 💙";
      default:
        return "How are you feeling today? 💭";
    }
  }

  // Streak celebrations
  static String getStreakCelebration(int streak) {
    if (streak <= 1) return '';
    
    final messages = [
      '$streak days in a row! You\'re building great habits! 🔥',
      'Amazing! $streak consecutive days of self-care! 🌟',
      'Consistency champion! $streak days strong! 💪',
      'Your dedication is inspiring! $streak days and counting! 🚀',
      'Incredible! $streak days of mindful tracking! 🧠✨',
    ];
    
    return messages[min(streak ~/ 3, messages.length - 1)];
  }

  // Daily affirmations
  static String getDailyAffirmation() {
    final affirmations = [
      "I am worthy of love and respect 💝",
      "I choose peace over worry 🕊️",
      "I am growing stronger every day 🌱",
      "I trust in my ability to overcome challenges 💪",
      "I am grateful for this moment 🙏",
      "I deserve happiness and joy 😊",
      "I am enough, just as I am ✨",
      "I choose to see the good in today 🌞",
      "I am in control of my thoughts and feelings 🧠",
      "I am creating a life I love ❤️",
      "I release what I cannot control 🍃",
      "I am resilient and adaptable 🌊",
      "I celebrate my progress, however small 🎉",
      "I am surrounded by love and support 🤗",
      "I choose self-compassion over self-criticism 💚",
    ];
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return affirmations[dayOfYear % affirmations.length];
  }

  // Daily activities
  static String getDailyActivity() {
    final activities = [
      '🧘 Practice 5-minute meditation',
      '👋 Wave to a classmate you recognize',
      '🛁 Take a relaxing bath or shower',
      '📚 Read a chapter of an interesting book',
      '💬 Ask someone about their day',
      '🌿 Water your plants and check their growth',
      '🎵 Listen to calming music for 10 minutes',
      '📝 Take notes on a topic you want to learn',
      '👥 Join a study group for your current class',
      '🫖 Make a cup of tea and enjoy it mindfully',
      '🛏️ Make your bed and organize your space',
      '🎯 Set a new goal for the week',
      '🍽️ Eat lunch with someone from your class',
      '🌅 Watch the sunrise or sunset',
      '🧹 Organize your study space',
      '📖 Learn a new word and use it today',
      '💭 Share your thoughts in class discussion',
      '🎨 Color or draw for 10 minutes',
      '🛋️ Take a 20-minute power nap',
      '🎓 Watch an educational video on a topic you enjoy',
      '👋 Greet someone new in your class',
      '🌙 Stargaze for 5 minutes before bed',
      '🧘 Do some gentle stretches',
      '📱 Learn a new feature of an app you use',
      '💬 Start a conversation about a shared interest',
      '🪴 Care for a plant or start growing one',
      '🛀 Take a long, relaxing shower',
      '📚 Read an article about something interesting',
      '👥 Join a discussion in your class',
      '🌿 Open your window and breathe fresh air',
      '🎵 Create a calming playlist for studying',
    ];
    
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return activities[dayOfYear % activities.length];
  }

  // Wellness tips based on mood patterns
  static String getPersonalizedWellnessTip(List<Mood> recentMoods) {
    if (recentMoods.isEmpty) {
      return "Start your wellness journey with a simple breathing exercise 🫁";
    }

    final averageRating = recentMoods.take(7).map((m) => m.rating).reduce((a, b) => a + b) / min(7, recentMoods.length);
    
    if (averageRating >= 4) {
      final tips = [
        "Keep up the great work! Try adding a gratitude journal to your routine 📝",
        "You're doing wonderfully! Consider sharing your positive energy with others 🌟",
        "Maintain your momentum with regular exercise or nature walks 🚶‍♀️",
      ];
      return tips[DateTime.now().day % tips.length];
    } else if (averageRating >= 2.5) {
      final tips = [
        "Try the 5-4-3-2-1 grounding technique when feeling overwhelmed 🧘‍♀️",
        "Consider reaching out to a friend or loved one today 👥",
        "A few minutes of deep breathing can work wonders 🫁",
      ];
      return tips[DateTime.now().day % tips.length];
    } else {
      final tips = [
        "Remember: it's okay to ask for help. You're not alone 🤝",
        "Try gentle self-care activities like warm tea or soft music 🍵",
        "Consider speaking with a mental health professional 💙",
      ];
      return tips[DateTime.now().day % tips.length];
    }
  }

  // Gratitude prompts
  static String getGratitudePrompt() {
    final prompts = [
      "What made you smile today? 😊",
      "Name someone who made your day better 👥",
      "What's one thing about your home you appreciate? 🏡",
      "Which of your strengths helped you today? 💪",
      "What's something beautiful you noticed today? 🌸",
      "What comfort brought you peace today? ☮️",
      "Which memory made you happy recently? 💭",
      "What opportunity are you thankful for? 🚪",
      "Name a skill you're grateful to have 🎯",
      "What aspect of your health are you appreciating? 🌿",
    ];
    
    return prompts[DateTime.now().day % prompts.length];
  }

  // Private helper methods
  static Future<Map<String, dynamic>> _getCurrentWeather() async {
    final position = await _getCurrentPosition();
    
    final response = await http.get(
      Uri.parse('$_weatherBaseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_weatherApiKey&units=metric'),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to get weather data');
  }

  static Future<Position> _getCurrentPosition() async {
    final permission = await Permission.location.request();
    if (permission != PermissionStatus.granted) {
      throw Exception('Location permission denied');
    }
    
    return await Geolocator.getCurrentPosition();
  }

  static String _getWeatherMessage(Map<String, dynamic> weather) {
    final main = weather['weather'][0]['main'].toLowerCase();
    final temp = weather['main']['temp'].round();
    
    switch (main) {
      case 'rain':
        return "Rainy day? Perfect for some cozy self-care indoors ☔";
      case 'clouds':
        return "Cloudy skies, but your mood can still shine bright! ☁️✨";
      case 'clear':
        return "Beautiful clear day! Maybe take a moment to enjoy the sunshine ☀️";
      case 'snow':
        return "Snowy day! Time for warm drinks and gentle reflection ❄️";
      case 'thunderstorm':
        return "Stormy weather outside? Create calm within 🌩️🧘‍♀️";
      default:
        return "Weather is ${temp}°C - a perfect day for self-care! 🌡️";
    }
  }

  static String _getRandomDefaultMessage() {
    final messages = [
      "Take a deep breath and embrace this moment 🫁",
      "You're doing better than you think! 💙",
      "Every small step counts on your wellness journey 👣",
      "Be kind to yourself today 🤗",
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }
} 
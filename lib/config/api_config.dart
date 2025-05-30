import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    // Try to get from environment variable first
    String? envUrl = dotenv.env['API_BASE_URL'];
    
    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // Fallback to localhost for development
    if (kDebugMode) {
      return 'http://localhost:3000/api';
    }
    
    // Production fallback - you can change this to your production URL
    return 'http://localhost:3000/api';
  }
} 
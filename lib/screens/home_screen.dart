import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import 'chat_screen.dart';
import 'resources_screen.dart';
import 'profile_screen.dart';
import 'wellness_screen.dart';
import 'auth_screen.dart';
import 'discussion_board_screen.dart';
import 'mood_history_screen.dart';
import '../widgets/mood_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _currentTipIndex = 0;

  final List<Widget> _screens = [
    const _DashboardTab(),
    const ChatScreen(),
    const WellnessScreen(),
    const ResourcesScreen(),
    const ProfileScreen(),
  ];

  final List<_DailyTip> _dailyTips = [
    _DailyTip(
      title: 'Practice Mindfulness',
      description: 'Take a few minutes each day to focus on your breath and be present in the moment.',
      icon: Icons.self_improvement,
      url: 'https://www.youtube.com/watch?v=inpok4MKVLM',
    ),
    _DailyTip(
      title: 'Stay Hydrated',
      description: 'Drinking enough water can help improve your mood and energy levels.',
      icon: Icons.water_drop,
    ),
    _DailyTip(
      title: 'Take a Walk',
      description: 'A short walk outside can help clear your mind and boost your mood.',
      icon: Icons.directions_walk,
    ),
    _DailyTip(
      title: 'Practice Gratitude',
      description: 'Write down three things you\'re grateful for each day.',
      icon: Icons.favorite,
    ),
    _DailyTip(
      title: 'Get Enough Sleep',
      description: 'Aim for 7-9 hours of quality sleep each night.',
      icon: Icons.nightlight_round,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.purple.shade800,
            ],
          ),
        ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.quicksand(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.spa_rounded),
                label: 'Wellness',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                label: 'Resources',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTipDetails(_DailyTip tip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(tip.icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tip.title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            if (tip.url != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _launchURL(tip.url!),
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Watch Video'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade900,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  int _currentTipIndex = 0;
  final List<_DailyTip> _dailyTips = [
    _DailyTip(
      title: 'Practice Mindfulness',
      description: 'Take a few minutes each day to focus on your breath and be present in the moment.',
      icon: Icons.self_improvement,
      url: 'https://www.youtube.com/watch?v=inpok4MKVLM',
    ),
    _DailyTip(
      title: 'Stay Hydrated',
      description: 'Drinking enough water can help improve your mood and energy levels.',
      icon: Icons.water_drop,
    ),
    _DailyTip(
      title: 'Take a Walk',
      description: 'A short walk outside can help clear your mind and boost your mood.',
      icon: Icons.directions_walk,
    ),
    _DailyTip(
      title: 'Practice Gratitude',
      description: 'Write down three things you\'re grateful for each day.',
      icon: Icons.favorite,
    ),
    _DailyTip(
      title: 'Get Enough Sleep',
      description: 'Aim for 7-9 hours of quality sleep each night.',
      icon: Icons.nightlight_round,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Welcome to MindCare',
                style: GoogleFonts.quicksand(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Consumer<MoodProvider>(
              builder: (context, moodProvider, child) {
                final hasMoodForToday = moodProvider.hasMoodForToday;
                final todayMood = moodProvider.todayMood;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today\'s Mood',
                            style: GoogleFonts.quicksand(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.history_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MoodHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!hasMoodForToday) ...[
                        Text(
                          'How are you feeling today?',
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const MoodInputSection(),
                      ] else if (todayMood != null) ...[
                        Row(
                          children: [
                            Icon(
                              _getMoodIcon(todayMood.rating),
                              size: 48,
                              color: _getMoodColor(todayMood.rating),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getMoodText(todayMood.rating),
                                    style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildMotivationalBoard(context),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Tips',
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _currentTipIndex = (_currentTipIndex + 2) % _dailyTips.length;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DailyTipCard(
                    title: _dailyTips[_currentTipIndex].title,
                    description: _dailyTips[_currentTipIndex].description,
                    icon: _dailyTips[_currentTipIndex].icon,
                  ),
                  const SizedBox(height: 16),
                  _DailyTipCard(
                    title: _dailyTips[(_currentTipIndex + 1) % _dailyTips.length].title,
                    description: _dailyTips[(_currentTipIndex + 1) % _dailyTips.length].description,
                    icon: _dailyTips[(_currentTipIndex + 1) % _dailyTips.length].icon,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Social Wellness Calendar',
                        style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '📅',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<MoodProvider>(
                    builder: (context, moodProvider, child) {
                      final todayMood = moodProvider.todayMood;
                      final moodColor = todayMood != null 
                          ? _getMoodColor(todayMood.rating)
                          : Colors.white;
                      
                      return Text(
                        'May 2025',
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: moodColor,
                          letterSpacing: 0.5,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 31,
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final category = _getActivityCategory(day);
                      return GestureDetector(
                        onTap: () => _showActivityDialog(context, day),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getCategoryColor(category).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              day.toString(),
                              style: GoogleFonts.quicksand(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _getCategoryColor(category),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMoodIcon(int rating) {
    switch (rating) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getMoodColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getMoodText(int rating) {
    switch (rating) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Neutral';
    }
  }

  String _getActivityCategory(int day) {
    final categories = [
      'mindfulness', // Day 1
      'social',      // Day 2
      'self-care',   // Day 3
      'learning',    // Day 4
      'social',      // Day 5
      'mindfulness', // Day 6
      'self-care',   // Day 7
      'learning',    // Day 8
      'social',      // Day 9
      'mindfulness', // Day 10
      'self-care',   // Day 11
      'learning',    // Day 12
      'social',      // Day 13
      'mindfulness', // Day 14
      'self-care',   // Day 15
      'learning',    // Day 16
      'social',      // Day 17
      'mindfulness', // Day 18
      'self-care',   // Day 19
      'learning',    // Day 20
      'social',      // Day 21
      'mindfulness', // Day 22
      'self-care',   // Day 23
      'learning',    // Day 24
      'social',      // Day 25
      'mindfulness', // Day 26
      'self-care',   // Day 27
      'learning',    // Day 28
      'social',      // Day 29
      'mindfulness', // Day 30
      'self-care',   // Day 31
    ];
    return categories[day - 1];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'mindfulness':
        return Colors.red.shade400;
      case 'social':
        return Colors.orange;
      case 'self-care':
        return Colors.yellow;
      case 'learning':
        return Colors.lightGreen;
      default:
        return Colors.green;
    }
  }

  String _getActivityEmoji(int day) {
    final emojis = [
      '🧘', // Practice 5-minute meditation
      '👋', // Wave to a classmate
      '🛁', // Take a relaxing bath
      '📚', // Read a chapter of a book
      '💬', // Ask about someone's day
      '🌿', // Water your plants
      '🎵', // Listen to calming music
      '📝', // Take notes on a new topic
      '👥', // Join a study group
      '🫖', // Make a cup of tea
      '🛏️', // Make your bed
      '🎯', // Set a new goal
      '🍽️', // Eat lunch with someone
      '🌅', // Watch the sunrise
      '🧹', // Organize your space
      '📖', // Learn a new word
      '💭', // Share your thoughts
      '🎨', // Color or draw
      '🛋️', // Take a power nap
      '🎓', // Watch an educational video
      '👋', // Greet someone new
      '🌙', // Stargaze for 5 minutes
      '🧘', // Do some stretches
      '📱', // Learn a new app feature
      '💬', // Start a conversation
      '🪴', // Care for a plant
      '🛀', // Take a long shower
      '📚', // Read an article
      '👥', // Join a discussion
      '🌿', // Open your window
      '🎵', // Create a playlist
    ];
    return emojis[day - 1];
  }

  String _getSocialActivity(int day) {
    final activities = [
      'Practice 5-minute meditation',
      'Wave to a classmate or colleague you recognize',
      'Take a relaxing bath or shower',
      'Read a chapter of an interesting book',
      'Ask someone about their day',
      'Water your plants and check their growth',
      'Listen to calming music',
      'Take notes on a topic you want to learn',
      'Spend time together in person',
      'Make a cup of tea and enjoy it mindfully',
      'Make your bed and organize your space',
      'Set a new goal for the week',
      'Eat lunch with someone from your class or workpace',
      'Watch the sunrise or sunset',
      'Organize your work space',
      'Learn a new word and use it today',
      'Give someone a compliment',
      'Color or draw',
      'Take a break from screens'
      'Watch an educational video on a topic you enjoy',
      'Greet someone new in your class or work',
      'Stargaze before bed',
      'Do some gentle stretches',
      'Learn a new feature of an app you use',
      'Start a conversation about a shared interest',
      'Care for a plant or start growing one',
      'Take a long, relaxing shower',
      'Read an article about something interesting',
      'Make a meal together',
      'Open your window and breathe fresh air',
      'Create a calming playlist for studying',
      'Listen to music while doing something you enjoy',
    ];
    return activities[day - 1];
  }

  void _showActivityDialog(BuildContext context, int day) {
    final category = _getActivityCategory(day);
    final categoryColor = _getCategoryColor(category);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                _getActivityEmoji(day),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day $day',
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: categoryColor,
                      ),
                    ),
                    Text(
                      category.toUpperCase(),
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: categoryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        content: Text(
          _getSocialActivity(day),
          style: GoogleFonts.quicksand(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.quicksand(
                color: categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoodInputSection extends StatefulWidget {
  const MoodInputSection({super.key});

  @override
  State<MoodInputSection> createState() => _MoodInputSectionState();
}

class _MoodInputSectionState extends State<MoodInputSection> {
  double _moodValue = 3.0;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
            valueIndicatorColor: Colors.white,
            valueIndicatorTextStyle: GoogleFonts.poppins(
              color: Colors.blue.shade900,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Slider(
            value: _moodValue,
            min: 1,
            max: 5,
            divisions: 4,
            label: _getMoodText(_moodValue.round()),
            onChanged: (value) {
              setState(() {
                _moodValue = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.sentiment_very_dissatisfied, size: 32, color: Colors.red),
              Icon(Icons.sentiment_dissatisfied, size: 32, color: Colors.orange),
              Icon(Icons.sentiment_neutral, size: 32, color: Colors.yellow),
              Icon(Icons.sentiment_satisfied, size: 32, color: Colors.lightGreen),
              Icon(Icons.sentiment_very_satisfied, size: 32, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitMood,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade900,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : Text(
                    'Save Mood',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitMood() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final moodProvider = Provider.of<MoodProvider>(context, listen: false);
      await moodProvider.addMood(_moodValue.round());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mood saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving mood: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _getMoodText(int rating) {
    switch (rating) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Neutral';
    }
  }
}

class _DailyTipCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _DailyTipCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMotivationalBoard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiscussionBoardScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900,
            Colors.purple.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.forum,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discussion Board',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your thoughts and connect with others',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class MoodSlider extends StatefulWidget {
  const MoodSlider({super.key});

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  double _value = 3.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _value,
          min: 1,
          max: 5,
          divisions: 4,
          label: _getMoodText(_value.round()),
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('😢', style: TextStyle(fontSize: 24)),
            Text('😐', style: TextStyle(fontSize: 24)),
            Text('😊', style: TextStyle(fontSize: 24)),
          ],
        ),
      ],
    );
  }

  String _getMoodText(int rating) {
    switch (rating) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      case 5:
        return 'Very Happy';
      default:
        return 'Neutral';
    }
  }
}

class SaveMoodButton extends StatelessWidget {
  const SaveMoodButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<MoodProvider, _MoodSliderState>(
      builder: (context, moodProvider, sliderState, child) {
        return ElevatedButton(
          onPressed: () async {
            try {
              await moodProvider.addMood(sliderState._value.round());
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mood saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error saving mood: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Text('Save Mood'),
        );
      },
    );
  }
}

class _DailyTip {
  final String title;
  final String description;
  final IconData icon;
  final String? url;

  const _DailyTip({
    required this.title,
    required this.description,
    required this.icon,
    this.url,
  });
} 
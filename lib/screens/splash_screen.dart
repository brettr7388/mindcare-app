import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _isFirstTime = true;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Welcome to MindCare',
      'description': 'Your personal mental health companion',
      'icon': Icons.health_and_safety,
    },
    {
      'title': 'Track Your Mood',
      'description': 'Record and monitor your daily emotional well-being',
      'icon': Icons.mood,
    },
    {
      'title': 'Chat with AI',
      'description': 'Get support and guidance whenever you need it',
      'icon': Icons.chat,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    // Force reset the first-time flag
    await prefs.setBool('isFirstTime', true);
    setState(() {
      _isFirstTime = true;
      _isLoading = false;
    });
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    
    // Always go to auth screen after onboarding
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout(); // Force logout
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _onboardingData[index]['icon'] as IconData,
                      size: 150,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _onboardingData[index]['title'] as String,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _onboardingData[index]['description'] as String,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_currentPage == _onboardingData.length - 1)
                  ElevatedButton(
                    onPressed: _finishOnboarding,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Text('Get Started'),
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
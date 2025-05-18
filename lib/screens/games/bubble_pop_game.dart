import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/sound_manager.dart';

class BubblePopGame extends StatefulWidget {
  const BubblePopGame({super.key});

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> with SingleTickerProviderStateMixin {
  final List<Bubble> bubbles = [];
  final Random random = Random();
  int score = 0;
  int highScore = 0;
  bool isGameOver = false;
  final SoundManager _soundManager = SoundManager();
  late AnimationController _controller;
  Timer? _spawnTimer;
  Timer? _updateTimer;
  late double screenWidth;
  late double screenHeight;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _soundManager.playBackgroundMusic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
      _isInitialized = true;
      _startSpawningBubbles();
      _startUpdatingBubbles();
      // Add more initial bubbles immediately
      for (int i = 0; i < 6; i++) {
        _addBubble();
      }
    }
  }

  void _startUpdatingBubbles() {
    _updateTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isGameOver) {
        _updateBubbles();
      }
    });
  }

  void _startSpawningBubbles() {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (!isGameOver) {
        _addBubble();
      }
    });
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('bubble_pop_high_score') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('bubble_pop_high_score', score);
      setState(() {
        highScore = score;
      });
    }
  }

  void _addBubble() {
    if (bubbles.length < 12) {  // Increased max bubbles
      setState(() {
        bubbles.add(Bubble(
          x: random.nextDouble() * (screenWidth - 100),
          y: screenHeight - 100,  // Start slightly above bottom
          size: random.nextDouble() * 40 + 50,  // Random size between 50 and 90
          color: _getRandomPastelColor(),
          speed: random.nextDouble() * 0.5 + 0.5,  // Random speed between 0.5 and 1.0
          scale: 1.0,  // Initial scale for pop animation
        ));
      });
      try {
        _soundManager.playBubbleCreate();
      } catch (e) {
        print('Error playing bubble create sound: $e');
      }
    }
  }

  Color _getRandomPastelColor() {
    return Color.fromRGBO(
      random.nextInt(100) + 155,  // Light red
      random.nextInt(100) + 155,  // Light green
      random.nextInt(100) + 155,  // Light blue
      0.7,  // Slight transparency
    );
  }

  void _popBubble(int index) {
    setState(() {
      // Start pop animation
      bubbles[index].scale = 1.5;
      // Remove bubble after animation
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            bubbles.removeAt(index);
            score++;
            try {
              _soundManager.playBubblePop();
            } catch (e) {
              print('Error playing bubble pop sound: $e');
            }
            _saveHighScore();
          });
        }
      });
    });
  }

  void _updateBubbles() {
    setState(() {
      for (var bubble in bubbles) {
        bubble.y -= bubble.speed;  // Move bubble upward
      }
      // Remove bubbles that have floated off screen
      bubbles.removeWhere((bubble) => bubble.y < -bubble.size);
    });
  }

  void _restartGame() {
    setState(() {
      bubbles.clear();
      score = 0;
      isGameOver = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _spawnTimer?.cancel();
    _updateTimer?.cancel();
    _soundManager.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Bubble Pop',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 40), // For balance
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score: $score',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'High Score: $highScore',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ...bubbles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final bubble = entry.value;
                        return Positioned(
                          left: bubble.x,
                          top: bubble.y,
                          child: GestureDetector(
                            onTap: () => _popBubble(index),
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: bubble.scale * (1.0 + 0.1 * sin(_controller.value * 2 * pi)),
                                  child: Container(
                                    width: bubble.size,
                                    height: bubble.size,
                                    decoration: BoxDecoration(
                                      color: bubble.color,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: bubble.color.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      if (isGameOver)
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Game Over!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Final Score: $score',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: _restartGame,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue.shade900,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Play Again',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bubble {
  final double x;
  double y;
  final double size;
  final Color color;
  final double speed;
  double scale;  // For pop animation

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    this.scale = 1.0,
  });
} 
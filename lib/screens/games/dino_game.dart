import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/sound_manager.dart';

class DinoGame extends StatefulWidget {
  const DinoGame({super.key});

  @override
  State<DinoGame> createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame> {
  static const double dinoHeight = 50;
  static const double dinoWidth = 50;
  static const double obstacleWidth = 30;
  static const double obstacleHeight = 50;
  static const double groundHeight = 50;
  static const double jumpHeight = 100;
  static const double gameSpeed = 5;

  double dinoY = 0;
  double dinoVelocity = 0;
  bool isJumping = false;
  List<Obstacle> obstacles = [];
  Timer? gameTimer;
  int score = 0;
  int highScore = 0;
  bool isGameOver = false;
  final SoundManager _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _startGame();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('dino_high_score') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dino_high_score', score);
      setState(() {
        highScore = score;
      });
    }
  }

  void _startGame() {
    setState(() {
      dinoY = 0;
      dinoVelocity = 0;
      obstacles = [];
      score = 0;
      isGameOver = false;
    });

    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        // Update dino position
        if (isJumping) {
          dinoY += dinoVelocity;
          dinoVelocity += 0.8; // Gravity

          if (dinoY >= 0) {
            dinoY = 0;
            dinoVelocity = 0;
            isJumping = false;
          }
        }

        // Update obstacles
        for (var obstacle in obstacles) {
          obstacle.x -= gameSpeed;
        }
        obstacles.removeWhere((obstacle) => obstacle.x < -obstacleWidth);

        // Add new obstacles
        if (obstacles.isEmpty || obstacles.last.x < 300) {
          obstacles.add(Obstacle(
            x: MediaQuery.of(context).size.width,
            height: obstacleHeight,
          ));
        }

        // Check collisions
        for (var obstacle in obstacles) {
          if (_checkCollision(obstacle)) {
            _gameOver();
            return;
          }
        }

        // Update score
        score++;
      });
    });
  }

  bool _checkCollision(Obstacle obstacle) {
    return (obstacle.x < dinoWidth &&
        obstacle.x + obstacleWidth > 0 &&
        dinoY < obstacleHeight);
  }

  void _jump() {
    if (!isJumping && !isGameOver) {
      setState(() {
        isJumping = true;
        dinoVelocity = -15;
      });
      _soundManager.playJump();
    }
  }

  void _gameOver() {
    gameTimer?.cancel();
    _saveHighScore();
    setState(() {
      isGameOver = true;
    });
    _soundManager.playGameOver();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
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
              Colors.blue.shade900,
              Colors.purple.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Dino Runner',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'High Score: $highScore',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: isGameOver ? _startGame : _jump,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Ground
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: groundHeight,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        // Dino
                        Positioned(
                          bottom: groundHeight,
                          left: 50,
                          child: Transform.translate(
                            offset: Offset(0, -dinoY),
                            child: Container(
                              width: dinoWidth,
                              height: dinoHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        // Obstacles
                        ...obstacles.map((obstacle) => Positioned(
                              bottom: groundHeight,
                              left: obstacle.x,
                              child: Container(
                                width: obstacleWidth,
                                height: obstacle.height,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                        // Game Over Text
                        if (isGameOver)
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                    'Tap to play again',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      color: Colors.white,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Obstacle {
  double x;
  final double height;

  Obstacle({
    required this.x,
    required this.height,
  });
} 
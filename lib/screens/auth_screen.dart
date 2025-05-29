import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  // Animation controllers
  late AnimationController _formAnimationController;
  late AnimationController _successAnimationController;
  late AnimationController _notificationController;
  late List<Animation<Offset>> _fieldAnimations;
  late Animation<double> _successAnimation;
  late Animation<Offset> _notificationAnimation;
  
  // Password
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Create staggered animations for form fields
    _fieldAnimations = List.generate(
      4, // Number of form fields
      (index) => Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _formAnimationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      )),
    );
    
    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _notificationAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _notificationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start entrance animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _formAnimationController.forward();
      }
    });
    
    // Add password strength listener
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _formAnimationController.dispose();
    _successAnimationController.dispose();
    _notificationController.dispose();
    _passwordController.removeListener(_checkPasswordStrength);
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.red;
    
    if (password.isEmpty) {
      strength = 0.0;
      strengthText = '';
    } else if (password.length < 4) {
      strength = 0.2;
      strengthText = 'Very Weak';
      strengthColor = Colors.red;
    } else if (password.length < 6) {
      strength = 0.4;
      strengthText = 'Weak';
      strengthColor = Colors.orange;
    } else if (password.length < 8) {
      strength = 0.6;
      strengthText = 'Good';
      strengthColor = Colors.yellow.shade700;
    } else {
      // Check for mixed case, numbers, special characters
      bool hasUpper = password.contains(RegExp(r'[A-Z]'));
      bool hasLower = password.contains(RegExp(r'[a-z]'));
      bool hasDigits = password.contains(RegExp(r'[0-9]'));
      bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      
      int criteria = 0;
      if (hasUpper) criteria++;
      if (hasLower) criteria++;
      if (hasDigits) criteria++;
      if (hasSpecial) criteria++;
      
      if (criteria >= 3) {
        strength = 1.0;
        strengthText = 'Very Strong';
        strengthColor = Colors.green;
      } else if (criteria >= 2) {
        strength = 0.8;
        strengthText = 'Strong';
        strengthColor = Colors.lightGreen;
      } else {
        strength = 0.6;
        strengthText = 'Good';
        strengthColor = Colors.yellow.shade700;
      }
    }
    
    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  void _showNotification(String message, {bool isError = true}) {
    // Reset and show notification
    _notificationController.reset();
    _notificationController.forward();
    
    // Auto hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _notificationController.reverse();
      }
    });
    
    // Show overlay
    if (mounted) {
      OverlayEntry? overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          child: SlideTransition(
            position: _notificationAnimation,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isError ? Colors.red.shade600 : Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isError ? Icons.error : Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      
      Overlay.of(context).insert(overlayEntry);
      
      // Remove overlay after animation
      Future.delayed(const Duration(seconds: 4), () {
        overlayEntry?.remove();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (_isLogin) {
        await authProvider.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // Show success animation without notification
        _successAnimationController.forward();
        
        // Small delay to show animation before navigation
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        await authProvider.signup(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // Show success notification and animation
        _showNotification(
          'Account created successfully! Welcome to MindCare',
          isError: false,
        );
        _successAnimationController.forward();
        
        // Small delay to show animation before navigation
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'An error occurred. Please try again.';
        
        // Customize error messages based on error type
        if (e.toString().contains('Invalid credentials') || 
            e.toString().contains('Wrong password') ||
            e.toString().contains('User not found')) {
          errorMessage = 'Invalid email or password. Please check your credentials.';
        } else if (e.toString().contains('Email already exists')) {
          errorMessage = 'An account with this email already exists. Try logging in instead.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your internet connection.';
        }
        
        _showNotification(errorMessage, isError: true);
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          SlideTransition(
                            position: _fieldAnimations[0],
                            child: FadeTransition(
                              opacity: _formAnimationController,
                              child: Text(
                                _isLogin ? 'MindCare Login' : 'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SlideTransition(
                            position: _fieldAnimations[0],
                            child: FadeTransition(
                              opacity: _formAnimationController,
                              child: Text(
                                _isLogin 
                                    ? 'Welcome back to your wellness journey'
                                    : 'Start your mental health journey today',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          if (!_isLogin) ...[
                            SlideTransition(
                              position: _fieldAnimations[1],
                              child: FadeTransition(
                                opacity: _formAnimationController,
                                child: TextFormField(
                                  controller: _nameController,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    labelStyle: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(20),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          SlideTransition(
                            position: _fieldAnimations[_isLogin ? 1 : 2],
                            child: FadeTransition(
                              opacity: _formAnimationController,
                              child: TextFormField(
                                controller: _emailController,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(20),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SlideTransition(
                            position: _fieldAnimations[_isLogin ? 2 : 3],
                            child: FadeTransition(
                              opacity: _formAnimationController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outlined,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(20),
                                    ),
                                    obscureText: !_isPasswordVisible,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  if (!_isLogin && _passwordController.text.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Password Strength: ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.white.withOpacity(0.7),
                                                ),
                                              ),
                                              Text(
                                                _passwordStrengthText,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: _passwordStrengthColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: _passwordStrength,
                                              backgroundColor: Colors.white.withOpacity(0.2),
                                              valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                                              minHeight: 6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SlideTransition(
                            position: _fieldAnimations[3],
                            child: FadeTransition(
                              opacity: _formAnimationController,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.blue.shade900,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 2,
                                        shadowColor: Colors.black.withOpacity(0.1),
                                      ),
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Colors.blue.shade900,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              _isLogin ? 'Login to MindCare' : 'Create Account',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                  // Success Animation Overlay
                                  if (_successAnimationController.isAnimating)
                                    Positioned.fill(
                                      child: ScaleTransition(
                                        scale: _successAnimation,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 32,
                                            ),
                                          ),
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
                    const SizedBox(height: 24),
                    SlideTransition(
                      position: _fieldAnimations[3],
                      child: FadeTransition(
                        opacity: _formAnimationController,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                            // Restart form animations for smooth transition
                            _formAnimationController.reset();
                            _formAnimationController.forward();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          ),
                          child: Text(
                            _isLogin
                                ? 'New to MindCare? Create an account'
                                : 'Already have an account? Sign in',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
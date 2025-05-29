import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import 'auth_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              children: const [
                _UserIdentitySection(),
                SizedBox(height: 16),
                _StatsSection(),
                SizedBox(height: 16),
                _WellnessInsightsSection(),
                SizedBox(height: 16),
                _SettingsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserIdentitySection extends StatelessWidget {
  const _UserIdentitySection();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, MoodProvider>(
      builder: (context, authProvider, moodProvider, child) {
        final activeDays = _calculateActiveDays(moodProvider.moods);
        
        return Container(
          margin: const EdgeInsets.all(16),
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
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                authProvider.userName ?? 'User Name',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$activeDays Days Active',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                authProvider.userEmail ?? 'user@mindcare.com',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              if (moodProvider.moods.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '"${_getMotivationalQuote(moodProvider.moods)}"',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  int _calculateActiveDays(List moods) {
    if (moods.isEmpty) return 0;
    
    final uniqueDays = <String>{};
    for (final mood in moods) {
      if (mood.timestamp != null) {
        final date = mood.timestamp;
        final dayKey = '${date.year}-${date.month}-${date.day}';
        uniqueDays.add(dayKey);
      }
    }
    return uniqueDays.length;
  }

  String _getMotivationalQuote(List moods) {
    if (moods.isEmpty) return 'Starting your wellness journey!';
    
    final totalMoods = moods.length;
    final averageRating = moods.fold<double>(0, (sum, mood) => sum + mood.rating) / totalMoods;
    
    if (totalMoods >= 30) {
      return 'Consistency champion! 🏆';
    } else if (totalMoods >= 14) {
      return 'Building great habits! 💪';
    } else if (totalMoods >= 7) {
      return 'One week strong! 🌟';
    } else if (averageRating >= 4) {
      return 'Spreading positivity! ✨';
    } else {
      return 'Taking it one day at a time 🌱';
    }
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Consumer<MoodProvider>(
        builder: (context, moodProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Wellness Stats',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Moods Logged',
                      '${moodProvider.moods.length}',
                      Icons.mood,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Days Active',
                      _calculateActiveDays(moodProvider.moods).toString(),
                      Icons.calendar_today,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Average Mood',
                      _calculateAverageMood(moodProvider.moods),
                      Icons.trending_up,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Current Streak',
                      _calculateStreak(moodProvider.moods).toString(),
                      Icons.local_fire_department,
                      Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMoodBreakdown(moodProvider.moods),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBreakdown(List moods) {
    final moodCounts = _getMoodCounts(moods);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Breakdown',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...moodCounts.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                _getMoodEmoji(entry.key),
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getMoodText(entry.key),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              Text(
                '${entry.value}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  int _calculateActiveDays(List moods) {
    if (moods.isEmpty) return 0;
    
    final uniqueDays = <String>{};
    for (final mood in moods) {
      if (mood.timestamp != null) {
        final date = mood.timestamp;
        final dayKey = '${date.year}-${date.month}-${date.day}';
        uniqueDays.add(dayKey);
      }
    }
    return uniqueDays.length;
  }

  String _calculateAverageMood(List moods) {
    if (moods.isEmpty) return 'N/A';
    
    final total = moods.fold<double>(0, (sum, mood) => sum + mood.rating);
    final average = total / moods.length;
    return average.toStringAsFixed(1);
  }

  int _calculateStreak(List moods) {
    if (moods.isEmpty) return 0;
    
    // Sort moods by date (newest first)
    final sortedMoods = List.from(moods);
    sortedMoods.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    int streak = 0;
    DateTime? lastDate;
    
    for (final mood in sortedMoods) {
      final currentDate = DateTime(
        mood.timestamp.year,
        mood.timestamp.month,
        mood.timestamp.day,
      );
      
      if (lastDate == null) {
        // First mood, check if it's today or yesterday
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final yesterdayDate = todayDate.subtract(const Duration(days: 1));
        
        if (currentDate == todayDate || currentDate == yesterdayDate) {
          streak = 1;
          lastDate = currentDate;
        } else {
          break;
        }
      } else {
        // Check if this mood is from the previous day
        final expectedDate = lastDate.subtract(const Duration(days: 1));
        if (currentDate == expectedDate) {
          streak++;
          lastDate = currentDate;
        } else {
          break;
        }
      }
    }
    
    return streak;
  }

  Map<int, int> _getMoodCounts(List moods) {
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final mood in moods) {
      counts[mood.rating] = (counts[mood.rating] ?? 0) + 1;
    }
    return counts;
  }

  String _getMoodEmoji(int rating) {
    switch (rating) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '😊';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String _getMoodText(int rating) {
    switch (rating) {
      case 1: return 'Very Sad';
      case 2: return 'Sad';
      case 3: return 'Neutral';
      case 4: return 'Happy';
      case 5: return 'Very Happy';
      default: return 'Neutral';
    }
  }
}

class _WellnessInsightsSection extends StatelessWidget {
  const _WellnessInsightsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Insights',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem('Stress Level', 'Low'),
          const SizedBox(height: 12),
          _buildInsightItem('Mood Stability', 'High'),
          const SizedBox(height: 12),
          _buildInsightItem('Mental Health Awareness', 'Good'),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Data Control',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            'Edit Profile',
            'Name, avatar, pronouns',
            Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
          _buildSettingsItem(
            'Reminders',
            'Mood tracking, check-ins',
            Icons.notifications,
            onTap: () {},
          ),
          _buildSettingsItem(
            'Download Data',
            'Export mood logs (CSV)',
            Icons.download,
            onTap: () {},
          ),
          _buildSettingsItem(
            'Privacy & Security',
            'PIN, data privacy',
            Icons.security,
            onTap: () {},
          ),
          const Divider(color: Colors.white24),
          _buildSettingsItem(
            'Logout',
            'Sign out of your account',
            Icons.logout,
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.8),
      ),
      onTap: onTap,
    );
  }
} 
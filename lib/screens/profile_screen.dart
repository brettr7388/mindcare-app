import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import 'auth_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
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
                _MoodSummarySection(),
                SizedBox(height: 16),
                _GoalsSection(),
                SizedBox(height: 16),
                _SelfCareToolkitSection(),
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
    final authProvider = Provider.of<AuthProvider>(context);
    
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
            '7 Days Active',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"Taking it one day at a time"',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodSummarySection extends StatelessWidget {
  const _MoodSummarySection();

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
            'Mood & Progress Summary',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const _MoodCalendar(),
          const SizedBox(height: 24),
          const _MoodTrendGraph(),
          const SizedBox(height: 24),
          const _MoodStats(),
        ],
      ),
    );
  }
}

class _MoodCalendar extends StatelessWidget {
  const _MoodCalendar();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 3, 1); // 3 months ago
    final lastDay = DateTime(now.year, now.month + 3, 0); // 3 months ahead

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: now,
      currentDay: now,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        defaultTextStyle: GoogleFonts.poppins(color: Colors.white),
        weekendTextStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        outsideTextStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.3)),
        todayDecoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        formatButtonVisible: false,
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
      selectedDayPredicate: (day) => isSameDay(day, now),
      onDaySelected: (selectedDay, focusedDay) {
        // Handle day selection
      },
    );
  }
}

class _MoodTrendGraph extends StatelessWidget {
  const _MoodTrendGraph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 4),
                const FlSpot(2, 3.5),
                const FlSpot(3, 5),
                const FlSpot(4, 4),
                const FlSpot(5, 4.5),
                const FlSpot(6, 4),
              ],
              isCurved: true,
              color: Colors.white,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.white.withOpacity(0.1),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class _MoodStats extends StatelessWidget {
  const _MoodStats();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Log Stats',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatRow('Most common mood this month', 'Happy 😊'),
        const SizedBox(height: 8),
        _buildStatRow('Good days', '15'),
        const SizedBox(height: 8),
        _buildStatRow('Neutral days', '10'),
        const SizedBox(height: 8),
        _buildStatRow('Tough days', '5'),
        const SizedBox(height: 8),
        _buildStatRow('Days logged', '25/30'),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
          style: GoogleFonts.poppins(
            fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
    );
  }
}

class _GoalsSection extends StatelessWidget {
  const _GoalsSection();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Goals & Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  // Add new goal
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGoalItem(
            'Practice gratitude',
            '3 times this week',
            0.6,
          ),
          const SizedBox(height: 16),
          _buildGoalItem(
            'Meditation',
            '10 minutes daily',
            0.8,
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Achievements',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildAchievement('7 Day Streak 🔥', 'Logged mood for a week straight'),
          const SizedBox(height: 12),
          _buildAchievement('Mindfulness Master 🧘', 'Completed 5 meditation sessions'),
          const SizedBox(height: 12),
          _buildAchievement('Reflection Pro ✍️', 'Wrote 3 journal entries'),
        ],
      ),
    );
  }

  Widget _buildGoalItem(String title, String subtitle, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
                ],
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildAchievement(String title, String description) {
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
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 32,
          ),
        ],
      ),
    );
  }
}

class _SelfCareToolkitSection extends StatelessWidget {
  const _SelfCareToolkitSection();

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
            'Self-Care Toolkit',
            style: GoogleFonts.poppins(
              fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildToolkitItem(
            'Saved Resources',
            '5 videos, 3 articles',
            Icons.bookmark,
          ),
          const SizedBox(height: 12),
          _buildToolkitItem(
            'Coping Strategies',
            '8 favorite techniques',
            Icons.psychology,
          ),
          const SizedBox(height: 12),
          _buildToolkitItem(
            'My Affirmations',
            '6 personal mantras',
            Icons.favorite,
          ),
        ],
      ),
    );
  }

  Widget _buildToolkitItem(String title, String subtitle, IconData icon) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
            icon,
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
            title,
                  style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'games/bubble_pop_game.dart';
import 'games/color_match_game.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

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
                    'Wellness',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WellnessSection(
                        title: 'Meditation',
                        items: [
                          WellnessItem(
                            title: 'Guided Meditation',
                            description: '10-minute guided meditation for stress relief',
                            icon: Icons.self_improvement,
                            url: 'https://www.youtube.com/watch?v=inpok4MKVLM',
                          ),
                          WellnessItem(
                            title: 'Breathing Exercise',
                            description: '5-minute breathing exercise for anxiety',
                            icon: Icons.air,
                            url: 'https://www.youtube.com/watch?v=5G5J4cX5J9Y',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _WellnessSection(
                        title: 'Peaceful Music',
                        items: [
                          WellnessItem(
                            title: 'Calming Nature Sounds',
                            description: 'Relaxing sounds of nature',
                            icon: Icons.landscape,
                            url: 'https://www.youtube.com/watch?v=1ZYbU82GVz4',
                          ),
                          WellnessItem(
                            title: 'Meditation Music',
                            description: 'Soothing meditation music',
                            icon: Icons.music_note,
                            url: 'https://www.youtube.com/watch?v=1ZYbU82GVz4',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _WellnessSection(
                        title: 'Mind Games',
                        items: [
                          WellnessItem(
                            title: 'Bubble Pop',
                            description: 'A calming game to help you relax and focus',
                            icon: Icons.bubble_chart,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const BubblePopGame(),
                                ),
                              );
                            },
                          ),
                          WellnessItem(
                            title: 'Color Match',
                            description: 'Test your color perception and memory',
                            icon: Icons.color_lens,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ColorMatchGame(),
                                ),
                              );
                            },
                          ),
                        ],
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

class _WellnessSection extends StatelessWidget {
  final String title;
  final List<WellnessItem> items;

  const _WellnessSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _WellnessItemCard(item: item)),
        ],
      ),
    );
  }
}

class _WellnessItemCard extends StatelessWidget {
  final WellnessItem item;

  const _WellnessItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (item.url != null) {
              _launchURL(item.url!);
            } else if (item.onTap != null) {
              item.onTap!();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
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

class WellnessItem {
  final String title;
  final String description;
  final IconData icon;
  final String? url;
  final VoidCallback? onTap;

  WellnessItem({
    required this.title,
    required this.description,
    required this.icon,
    this.url,
    this.onTap,
  });
} 
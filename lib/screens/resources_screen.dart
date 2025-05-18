import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ResourceCard(
            title: 'Understanding Mental Health',
            description: 'Learn about common mental health conditions and how to maintain good mental well-being.',
            icon: Icons.psychology,
            url: 'https://www.who.int/mental_health/en/',
          ),
          _ResourceCard(
            title: 'Crisis Hotlines',
            description: 'Immediate support is available 24/7. You\'re not alone.',
            icon: Icons.phone,
            url: 'https://www.nimh.nih.gov/health/find-help',
          ),
          _ResourceCard(
            title: 'Meditation Guide',
            description: 'Simple meditation techniques to help reduce stress and anxiety.',
            icon: Icons.self_improvement,
            url: 'https://www.headspace.com/meditation/meditation-for-beginners',
          ),
          _ResourceCard(
            title: 'Exercise & Mental Health',
            description: 'How physical activity can improve your mental well-being.',
            icon: Icons.fitness_center,
            url: 'https://www.mentalhealth.org.uk/a-to-z/e/exercise-and-mental-health',
          ),
          _ResourceCard(
            title: 'Sleep Hygiene',
            description: 'Tips for better sleep and its impact on mental health.',
            icon: Icons.bedtime,
            url: 'https://www.sleepfoundation.org/sleep-hygiene',
          ),
          _ResourceCard(
            title: 'Nutrition & Mental Health',
            description: 'How diet affects your mental well-being.',
            icon: Icons.restaurant,
            url: 'https://www.mentalhealth.org.uk/a-to-z/d/diet-and-mental-health',
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String url;

  const _ResourceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.url,
  });

  Future<void> _launchURL() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _launchURL,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
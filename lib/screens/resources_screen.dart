import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'Resources',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 40), // For balance
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ResourceSection(
                        title: 'Crisis Hotlines',
                        resources: [
                          Resource(
                            title: 'National Suicide Prevention Lifeline',
                            description: '24/7 support for people in suicidal crisis or emotional distress',
                            phone: '988',
                            url: 'https://988lifeline.org',
                          ),
                          Resource(
                            title: 'Crisis Text Line',
                            description: 'Text HOME to 741741 to connect with a Crisis Counselor',
                            phone: '741741',
                            url: 'https://www.crisistextline.org',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _ResourceSection(
                        title: 'Mental Health Resources',
                        resources: [
                          Resource(
                            title: 'SAMHSA\'s National Helpline',
                            description: 'Treatment referral and information service',
                            phone: '1-800-662-4357',
                            url: 'https://www.samhsa.gov/find-help/national-helpline',
                          ),
                          Resource(
                            title: 'MentalHealth.gov',
                            description: 'Information and resources on mental health',
                            url: 'https://www.mentalhealth.gov',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _ResourceSection(
                        title: 'Support Groups',
                        resources: [
                          Resource(
                            title: 'NAMI Connection',
                            description: 'Peer-led support group for people with mental health conditions',
                            url: 'https://www.nami.org/help',
                          ),
                          Resource(
                            title: 'Depression and Bipolar Support Alliance',
                            description: 'Peer support groups for depression and bipolar disorder',
                            url: 'https://www.dbsalliance.org',
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

class _ResourceSection extends StatelessWidget {
  final String title;
  final List<Resource> resources;

  const _ResourceSection({
    required this.title,
    required this.resources,
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
          ...resources.map((resource) => _ResourceCard(resource: resource)),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final Resource resource;

  const _ResourceCard({required this.resource});

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
          onTap: () => _launchURL(resource.url),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  resource.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                if (resource.phone != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        resource.phone!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
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

class Resource {
  final String title;
  final String description;
  final String? phone;
  final String url;

  Resource({
    required this.title,
    required this.description,
    this.phone,
    required this.url,
  });
} 
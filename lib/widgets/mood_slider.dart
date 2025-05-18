import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const MoodSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMoodLabel(1, 'Very Bad'),
            _buildMoodLabel(2, 'Bad'),
            _buildMoodLabel(3, 'Neutral'),
            _buildMoodLabel(4, 'Good'),
            _buildMoodLabel(5, 'Very Good'),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Icon(
            _getMoodIcon(value.round()),
            size: 48,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodLabel(int rating, String label) {
    return Column(
      children: [
        Icon(
          _getMoodIcon(rating),
          color: Colors.white.withOpacity(0.6),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
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
} 
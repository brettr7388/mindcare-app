import 'package:flutter/material.dart';

class NoteInput extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const NoteInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add a note (optional)',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 3,
            onChanged: onChanged,
            controller: TextEditingController(text: value),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'How are you feeling today?',
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey[400],
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
} 
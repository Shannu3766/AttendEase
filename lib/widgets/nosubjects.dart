import 'package:flutter/material.dart';

class Nosubjects extends StatefulWidget {
  const Nosubjects({
    super.key,
    required this.showAddSubjectScreen,
    required this.message,
    required this.button_text,
  });
  final Function showAddSubjectScreen;
  final String message;
  final String button_text;
  @override
  State<Nosubjects> createState() => _NosubjectsState();
}

class _NosubjectsState extends State<Nosubjects> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: Colors.blue.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => widget.showAddSubjectScreen(),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: Text(
              widget.button_text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}

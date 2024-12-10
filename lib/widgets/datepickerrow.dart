import 'package:flutter/material.dart';

class DatePickerRow extends StatelessWidget {
  final String formattedDate;
  final VoidCallback onCalendarPressed;

  const DatePickerRow({
    super.key,
    required this.formattedDate,
    required this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4), // Shadow position
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Selected Date:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12.0), // Spacing between container and button
        CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.blue,
          child: IconButton(
            onPressed: onCalendarPressed,
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

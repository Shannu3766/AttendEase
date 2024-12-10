import 'package:flutter/material.dart';

class Custom_ElevatedButtonicon extends StatelessWidget {
  final void Function() function;
  final IconData icon;
  final String text;
  const Custom_ElevatedButtonicon(
      {super.key,
      required this.function,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          // update_attendece();
          function();
        },
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5, // Shadow effect
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
  }
}

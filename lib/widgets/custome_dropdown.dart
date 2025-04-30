import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String labelText;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: DropdownButtonFormField<String>(
        hint: Text(
          hintText,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        icon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
        items: const [
          DropdownMenuItem(value: 'Sem1', child: Text('Sem 1')),
          DropdownMenuItem(value: 'Sem2', child: Text('Sem 2')),
          DropdownMenuItem(value: 'Sem3', child: Text('Sem 3')),
          DropdownMenuItem(value: 'Sem4', child: Text('Sem 4')),
          DropdownMenuItem(value: 'Sem5', child: Text('Sem 5')),
          DropdownMenuItem(value: 'Sem6', child: Text('Sem 6')),
          DropdownMenuItem(value: 'Sem7', child: Text('Sem 7')),
          DropdownMenuItem(value: 'Sem8', child: Text('Sem 8')),
        ],
      ),
    );
  }
}

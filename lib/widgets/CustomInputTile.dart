import 'package:flutter/material.dart';

class CustomInputTile extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final bool isnum;
  final String intialvalue;

  const CustomInputTile({
    Key? key,
    required this.icon,
    required this.labelText,
    required this.onChanged,
    required this.validator,
    required this.isnum,
    required this.intialvalue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        keyboardType: isnum ? TextInputType.number : TextInputType.text,
        initialValue: intialvalue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

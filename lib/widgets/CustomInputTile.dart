import 'package:flutter/material.dart';

class CustomInputTile extends StatelessWidget {
  final IconData icon;
  // final String hintText;
  final String labelText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final bool isnum;
  final String intialvalue;

  const CustomInputTile({
    Key? key,
    required this.icon,
    // required this.hintText,
    required this.labelText,
    required this.onChanged,
    required this.validator,
    required this.isnum,
    required this.intialvalue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        keyboardType: isnum ? TextInputType.number : TextInputType.text,
        initialValue: intialvalue,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            label: Text(labelText),
            border: OutlineInputBorder(
              gapPadding: 2.0,
              borderRadius: BorderRadius.circular(40.0),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            )),
      ),
    );
  }
}

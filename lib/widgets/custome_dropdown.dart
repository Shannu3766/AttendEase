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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      // padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: ListTile(
        title: DropdownButtonFormField(
          // icon: Icon(Icons.clean_hands),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          hint: Text(hintText),
          items: const [
            DropdownMenuItem(
              child: Text('Sem 1'),
              value: 'Sem1',
            ),
            DropdownMenuItem(
              child: Text('Sem 2'),
              value: 'Sem2',
            ),
            DropdownMenuItem(
              child: Text('Sem 3'),
              value: 'Sem3',
            ),
            DropdownMenuItem(
              child: Text('Sem 4'),
              value: 'Sem4',
            ),
            DropdownMenuItem(
              child: Text('Sem 5'),
              value: 'Sem5',
            ),
            DropdownMenuItem(
              child: Text('Sem 6'),
              value: 'Sem6',
            ),
            DropdownMenuItem(
              child: Text('Sem 7'),
              value: 'Sem7',
            ),
            DropdownMenuItem(
              child: Text('Sem 8'),
              value: 'Sem8',
            ),
          ],
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}

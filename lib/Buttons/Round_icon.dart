import 'package:flutter/material.dart';

class RoundIcon extends StatelessWidget {
  RoundIcon({super.key, required this.address});
  String address;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
        ),
        Image.asset(
          address,
          height: 50,
        )
      ],
    );
  }
}

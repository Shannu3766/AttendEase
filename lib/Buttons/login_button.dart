import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendease/Buttons/Round_icon.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(255, 169, 216, 243),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          children: [
            const SizedBox(
              width: 30,
            ),
            RoundIcon(address: "assests/images/googleicon.png"),
            const Spacer(),
            Text(
              "Google",
              style: GoogleFonts.inter(
                fontSize: 33.08,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

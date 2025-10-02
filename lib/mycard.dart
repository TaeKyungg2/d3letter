import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyCard extends StatelessWidget {
  MyCard({super.key,required this.myColor, this.said});
  final Color myColor;
  Map? said;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: myColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          '${said!['text']}\n- ${said!['author']}',
          style: GoogleFonts.orbit(
            fontSize: 20,
            color: Color.fromARGB(246, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
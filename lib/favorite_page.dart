import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key,required List<Map> this.fav});
  final List<Map> fav;
  final random=Random();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: fav.map((item) {
        return ListTile(
          title: Text(item['text'],style:GoogleFonts.orbit()),
          subtitle: Text(item['author'],style:GoogleFonts.orbit()),
          tileColor: Color.fromARGB(50, random.nextInt(255), random.nextInt(255), random.nextInt(255)),
          onLongPress: () {
            
          },
        );
      }).toList(),
      ),
    );
  }
}

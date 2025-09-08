import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Text> fa_list = [
    Text('ABC',style:GoogleFonts.abel(),),
    Text('ABC'),
    Text('AfC'),
    Text('dBC'),
    Text('ABC'),
    Text('AfggfC'),
    Text('ENd'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
      ],
    );
  }
}

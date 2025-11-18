import 'package:flutter/material.dart';
import 'card_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const MyApp());
Future<List<dynamic>> loadSaids() async {
  final response = await http.get(
    Uri.parse(
      'https://gist.githubusercontent.com/TaeKyungg2/dd77b00e3929e3feb64be5bd411096cf/raw/saying.json',
    ),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load text');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'd3letters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Color.fromARGB(255, 0, 196, 226)),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'd3lettersHome'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/home.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            //colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.screen),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CardPage()));
                  },
                  child: Text(
                    '편지 도착        ',
                    style: GoogleFonts.gowunDodum(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

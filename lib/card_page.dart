import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class CardPage extends StatefulWidget {
  const CardPage({super.key});
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late Future<List<dynamic>> SaidList;

  @override
  void initState() {
    super.initState();
    SaidList = fetchSaid();
  }

  Future<List<dynamic>> fetchSaid() async {
    final response = await http.get(
      Uri.parse(
        'https://gist.githubusercontent.com/TaeKyungg2/dd77b00e3929e3feb64be5bd411096cf/raw/saying.json',
      ),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    var random = Random();
    int _currentIndex;
    int length;
    List<dynamic> saids = [];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('3letter', style: GoogleFonts.actor()),
        centerTitle: false,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    color: const Color.fromARGB(255, 25, 240, 193),
                    iconSize: 100,
                    onPressed: () {
                      print("눌림!");
                    },
                  ),
                  FutureBuilder(
                    future: SaidList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        saids = snapshot.data!;
                        length = saids.length;
                        return Card(
                          elevation: 30,
                          color: Color.fromARGB(255, 144, 224, 238),
                          child: SizedBox(
                            width: 350,
                            height: 400,
                            child: Center(
                              child: Text(
                                '${saids[random.nextInt(length)]['text']}\n- ${saids[random.nextInt(length)]['author']}',
                                style: GoogleFonts.songMyung(
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    color: const Color.fromARGB(255, 23, 220, 255),
                    iconSize: 100,
                    onPressed: () {
                      print("눌림!");
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

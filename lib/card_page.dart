import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:d3letters/favorite_page.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

Future<void> cacheFavorites(List<Map> favorites) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/favorites.json');
  final jsonString = jsonEncode(favorites);
  await file.writeAsString(jsonString);
}

Future<List<Map>> loadFavorites() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/favorites.json');
  if (await file.exists()) {
    final contents = await file.readAsString();
    final List<dynamic> decoded = jsonDecode(contents);
    return decoded.cast<Map>();
  } else {
    return [];
  }
}

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class MyCard extends StatelessWidget {
  MyCard({required Color this.myColor, Map? this.said});
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
          style: GoogleFonts.orbit(fontSize: 20),
        ),
      ),
    );
  }
}

class _CardPageState extends State<CardPage> {
  List<Map> fav = [];
  List<bool> cardLike = [false, false, false];
  List<dynamic> three = [];
  List<MyCard> cards = [
    MyCard(myColor: Color.fromARGB(255, 142, 204, 255), said: {"a": "b"}),
    MyCard(myColor: Color.fromARGB(255, 255, 211, 208), said: {"a": "b"}),
    MyCard(myColor: Color.fromARGB(255, 250, 219, 255), said: {"a": "b"}),
  ];
  Future<List<dynamic>> loadSaids() async {
    final response = await http.get(
      Uri.parse(
        'https://gist.githubusercontent.com/TaeKyungg2/dd77b00e3929e3feb64be5bd411096cf/raw/saying.json',
      ),
    );
    if (response.statusCode == 200) {
      int length;
      List<dynamic> saids = jsonDecode(response.body);
      length = saids.length;
      var random = Random();
      while (three.length < 3) {
        var temp = saids[random.nextInt(length)];
        if (!three.contains(temp)) {
          three.add(temp);
        }
      }
      cards[0].said = three[0];
      cards[1].said = three[1];
      cards[2].said = three[2];
      setState(() {});
      return three;
    } else {
      throw Exception('Failed to load text');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final loadedFavorites = await loadFavorites();
    loadSaids();
    setState(() {
      fav = loadedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool currentLike = false;
    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('3letter', style: GoogleFonts.actor()),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    DateTime.now().toString().substring(0, 10),
                    style: GoogleFonts.aBeeZee(fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: CardSwiper(
                allowedSwipeDirection: AllowedSwipeDirection.all(),
                padding: EdgeInsets.all(40),
                cardsCount: cards.length,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) =>
                        cards[index],
                numberOfCardsDisplayed: 3,
                maxAngle: 30,
                threshold: 50,
                scale: 0.9,
                isDisabled: false,
                onSwipe: (previousIndex, currentIndex, direction) {
                  setState(() {
                    currentLike = cardLike[currentIndex!];
                  });
                  return true;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FavoritePage(fav: fav),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(233, 6, 184, 255),
                      elevation: 0,
                    ),
                    child: Text(
                      'favorite',
                      style: GoogleFonts.aboreto(fontSize: 20),
                    ),
                  ),
                  LikeButton(
                    size: 50,
                    circleColor: CircleColor(
                      start: Color.fromARGB(246, 255, 225, 28),
                      end: Color.fromARGB(246, 0, 195, 255),
                    ),
                    isLiked: currentLike,
                    onTap: (isLiked) async {
                      if (!fav.contains(three[currentIndex])) {
                        setState(() {
                          fav.add(three[currentIndex]);
                          cardLike[currentIndex] = !isLiked;
                        });
                        await cacheFavorites(fav);
                      } else {
                        setState(() {
                          fav.remove(three[currentIndex]);
                          isLiked = cardLike[currentIndex];
                        });
                        await cacheFavorites(fav);
                      }

                      return !isLiked;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

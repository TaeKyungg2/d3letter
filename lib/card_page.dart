import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'cache_fav.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:d3letters/favorite_page.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> cacheThreeAndDate(List<Map> three, String date) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/three.json');
  final datefile = File('${dir.path}/date.txt');
  final jsonString = jsonEncode(three);
  await file.writeAsString(jsonString);
  await datefile.writeAsString(date);
}

Future<List<Map>> loadThree() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/three.json');
  if (await file.exists()) {
    final contents = await file.readAsString();
    final List<dynamic> decoded = jsonDecode(contents);
    return decoded.cast<Map>();
  } else {
    return [];
  }
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

Future<String> loadDate() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/date.txt');
  if (await file.exists()) {
    final contents = await file.readAsString();
    return contents;
  } else {
    return "null";
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
          style: GoogleFonts.orbit(
            fontSize: 20,
            color: Color.fromARGB(246, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}

class _CardPageState extends State<CardPage> {
  List<Map> fav = [];
  List<Map> three = [
    {"text": "letter", "author": "dev"},
    {"text": "letter", "author": "dev"},
    {"text": "letter", "author": "dev"},
  ];
  int cardValue = 0;
  List<MyCard> cards = [
    MyCard(
      myColor: Color.fromARGB(255, 132, 202, 237),
      said: {"text": "편지 오는 중...", "author": "taery"},
    ),
    MyCard(
      myColor: Color.fromARGB(255, 255, 211, 208),
      said: {"text": "편지 오는 중..", "author": "taery"},
    ),
    MyCard(
      myColor: Color.fromARGB(255, 250, 219, 255),
      said: {"text": "편지 오는 중..", "author": "taery"},
    ),
  ];
  Future<List<dynamic>> loadSaids() async {
    final String beforeDate = await loadDate();
    print(beforeDate);
    final threeCache = await loadThree();
    if (DateTime.now().toString().substring(0, 10) == beforeDate &&
        threeCache[1]["text"] != "letter") {
      print(threeCache[1]);
      print("goCache");
      three = threeCache;
      setState(() {
        three = threeCache;
        cardValue = 1;
      });
      return three;
    }
    print("noCache");
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
      cacheThreeAndDate(three, DateTime.now().toString().substring(0, 10));
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
    await loadSaids();
    setState(() {
      fav = loadedFavorites;
    });
  }

  bool checkLike(int index) {
    bool check;
    check = fav.any((said) => said["text"] == three[index]["text"]);
    return check;
  }

  int currentIndexMy = 0;

  @override
  Widget build(BuildContext context) {
    cards[0].said = three[0];
    cards[1].said = three[1];
    cards[2].said = three[2];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'd3letters',
          style: GoogleFonts.aboreto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(246, 255, 255, 255),
          ),
        ),
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
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 20,
                    right: 20,
                    bottom: 25,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  child: Text(
                    DateTime.now().toString().substring(0, 10) + " Letter",
                    style: GoogleFonts.aboreto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 253, 253, 253),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: CardSwiper(
                key: ValueKey(cardValue),
                allowedSwipeDirection: AllowedSwipeDirection.all(),
                padding: EdgeInsets.all(20),
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
                    currentIndexMy = currentIndex!;
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
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'favorite',
                        style: GoogleFonts.aboreto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(246, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    child: LikeButton(
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Colors.black26,
                          size: 40,
                        );
                      },
                      key: ValueKey(currentIndexMy),
                      size: 50,
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                        dotSecondaryColor: Theme.of(
                          context,
                        ).colorScheme.surface,
                      ),
                      circleColor: CircleColor(
                        start: Color.fromARGB(246, 255, 225, 28),
                        end: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      isLiked: checkLike(currentIndexMy),
                      onTap: (isLiked) async {
                        if (!fav.contains(three[currentIndexMy])) {
                          setState(() {
                            fav.add(three[currentIndexMy]);
                          });
                          await cacheFavorites(fav);
                        } else {
                          setState(() {
                            fav.remove(three[currentIndexMy]);
                          });
                          await cacheFavorites(fav);
                        }
                        return !isLiked;
                      },
                    ),
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

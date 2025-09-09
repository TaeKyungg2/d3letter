import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:d3letters/favorite_page.dart';
import 'package:like_button/like_button.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});
  @override
  State<CardPage> createState() => _CardPageState();
}
class MyCard extends StatelessWidget{
  MyCard({required Color this.myColor,required Map this.said});
  final Color myColor;
  final Map said;
  
  @override
  Widget build(BuildContext context)
  {
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
  late Future<List<dynamic>> saidList;
  List<Map> fav=[];
  @override
  void initState() {
    super.initState();
    saidList = fetchSaid();
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
      throw Exception('Failed to load text');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    int length;
    List<dynamic> saids = [];
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('3letter', style: GoogleFonts.actor()),
            centerTitle: false,
          ),
          body: Center(
            child: FutureBuilder(
              future: saidList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  saids = snapshot.data!;
                  length = saids.length;
                  List<dynamic> three = [];
                  var random = Random();
                  while (three.length < 3) {
                    var temp = saids[random.nextInt(length)];
                    if (!three.contains(temp)) {
                      three.add(temp);
                    }
                  }
                  List<MyCard> cards = [
                    MyCard(myColor: Color.fromARGB(255, 142, 204, 255),
                    said: three[0],),
                    MyCard(myColor: Color.fromARGB(255, 255, 211, 208),
                    said:three[1]),
                    MyCard(myColor: Color.fromARGB(255, 250, 219, 255),
                    said:three[2])
                  ];
                  int current=0;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
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
                          padding: EdgeInsetsGeometry.all(40),
                          cardsCount: cards.length,
                          cardBuilder:
                              (
                                context,
                                index,
                                percentThresholdX,
                                percentThresholdY,
                              ) => cards[index],
                          numberOfCardsDisplayed: 3,
                          maxAngle: 30,
                          threshold: 50,
                          scale: 0.9,
                          isDisabled: false,
                          onSwipe: (previousIndex, currentIndex, direction) {
                            current=currentIndex!;
                            return true; 
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FavoritePage(fav:fav),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(233, 6, 218, 255),
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
                              onTap:(isLiked) => onLikeButtonTapped(isLiked,three[current])
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        );
  }
  Future<bool> onLikeButtonTapped (bool isLiked,Map said)async{
    if(!fav.contains(said)){
      fav.add(said);
    }
  /// send your request here
  // final bool success= await sendRequest();

  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

    return !isLiked;
  }
}

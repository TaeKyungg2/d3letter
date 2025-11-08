import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'cache.dart';
import 'dart:developer' as dev;

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required this.fav});
  final List<Map> fav;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final random = Random();
  List<ListTile> favorite = [];
  @override
  Widget build(BuildContext context) {
    favorite = [];
    for (int i = 0; i < widget.fav.length; i++) {
      favorite.add(
        ListTile(
          key:ValueKey(widget.fav[i]["text"]),
          selected: false,
          title: Text(
            widget.fav[i]["text"],
            style: GoogleFonts.orbit(color: Colors.black),
          ),
          subtitle: Text(
            widget.fav[i]['author'],
            style: GoogleFonts.orbit(color: Colors.blueGrey),
          ),
          tileColor: i % 2 == 0
              ? Theme.of(context).colorScheme.inversePrimary
              : Colors.white,
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  title: Text(
                    "편지 반환",
                    style: GoogleFonts.orbit(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  content: Text(
                    "이 편지를 돌려보내시겠습니까?",
                    style: GoogleFonts.orbit(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      child: Text(
                        "취소",
                        style: GoogleFonts.orbit(
                          fontSize: 30,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        "삭제",
                        style: GoogleFonts.orbit(
                          fontSize: 30,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.fav.removeAt(
                            widget.fav.indexWhere((n) => n["text"] == widget.fav[i]["text"]),
                          );
                        });
                        dev.log('삭제 완료!');
                        cacheFavorites(widget.fav);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }
    return Scaffold(body: ListView(children: [...favorite]));
  }
}

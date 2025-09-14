import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'cache_fav.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required List<Map> this.fav});
  final List<Map> fav;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.fav.map((item) {
          return ListTile(
            title: Text(item['text'], style: GoogleFonts.orbit(color: Color.from(alpha: 255, red: 255, green: 255, blue: 255))),
            subtitle: Text(item['author'], style: GoogleFonts.orbit(color: Color.from(alpha: 255, red: 255, green: 255, blue: 255))),
            tileColor: Color.fromARGB(
              150,
              random.nextInt(30),
              random.nextInt(30),
              random.nextInt(255),
            ),
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("편지 반환"),
                    content: Text("이 편지를 돌려보내시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        child: Text("취소"),
                      ),
                      TextButton(
                        child: Text("삭제"),
                        onPressed: () {
                          setState(() {
                            widget.fav.removeAt(
                              widget.fav.indexWhere(
                                (n) => n["text"] == item["text"],
                              ),
                            );
                          });
                          print("삭제 완료!");
                          cacheFavorites(widget.fav);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

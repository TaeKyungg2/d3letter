import 'package:flutter/material.dart';
import 'card_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> cacheFile(String filename, String contents) async {
  final dir = await getApplicationDocumentsDirectory(); // 캐시용 디렉토리
  final file = File('${dir.path}/$filename');
  await file.writeAsString(contents);
}

Future<String> loadFile(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  if (await file.exists()) {
    return await file.readAsString();
  } else {
    String date = DateTime.now().toString().substring(10);
    await cacheFile(filename, date);
    return date;
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'd3letters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 78, 196, 255),
        ),
      ),
      home: const MyHomePage(title: 'Good Said'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<String> _data;
  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => CardPage()));
                },
                child: Text('✉️', style: TextStyle(fontSize: 100)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

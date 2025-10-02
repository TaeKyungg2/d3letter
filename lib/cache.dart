import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
Future<void> cacheFavorites(List<Map> favorites) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/favorites.json');
  final jsonString = jsonEncode(favorites);
  await file.writeAsString(jsonString);
}

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
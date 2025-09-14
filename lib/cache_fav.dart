import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
Future<void> cacheFavorites(List<Map> favorites) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/favorites.json');
  final jsonString = jsonEncode(favorites);
  await file.writeAsString(jsonString);
}
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> get _file async {
    final path = await _directoryPath;
    return File('$path/shoppinglist.txt');
  }

  Future<File> get _jsonFile async {
    final path = await _directoryPath;
    return File('$path/shoppinglist.json');
  }

  Future<String> readTextFile() async {
    String fileContent = 'لا يوجد مشتريات';
    File file = await _file;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }
    return fileContent;
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    String fileContent = 'لا يوجد مشتريات';
    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
      } catch (e) {
        print(e);
      }
    }
    return json.decode(fileContent);
  }

  Future<String> writeTextFile() async {
    String text = DateFormat('h:mm:ss').format(DateTime.now());
    File file = await _file;

    await file.writeAsString(text);

    return text;
  }

  Future<List> writeJsonFile() async {
    final List<Item> itemslist = items;
    File file = await _jsonFile;

    await file.writeAsString(json.encode(itemslist));

    return itemslist;
  }
}
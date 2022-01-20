import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/models/category.dart';
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

  Future<File> get _searchFile async {
    final path = await _directoryPath;
    return File('$path/searchlist.json');
  }

  Future<File> get _catFile async {
    final path = await _directoryPath;
    return File('$path/categories.json');
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
    return null;
  }

  Future<List> readJsonFile() async {
    String fileContent = 'Cart List';
    var jsonlist = [];
    File file = await _jsonFile;
    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        jsonlist = json.decode(fileContent);
        print(jsonlist);
        return jsonlist;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<List> readSearchFile() async {
    String fileContent = 'Search List';
    var searchlist = [];
    File file = await _searchFile;
    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        searchlist = json.decode(fileContent);
        print(searchlist);
        return searchlist;
      } catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<List> readCategoryFile() async {
    String fileContent = 'Category List';
    var categoryList = [];
    File file = await _catFile;
    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        categoryList = json.decode(fileContent);
        print(categoryList);
        return categoryList;
      } catch (e) {
        print(e);
      }
    }
    return null;
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
    var json = jsonEncode(itemslist.map((e) => e.toJson()).toList());

    await file.writeAsString(json);

    return itemslist;
  }

  Future<List> writeSearchFile() async {
    final List<Item> searchlist = items;
    File file = await _searchFile;
    var json = jsonEncode(searchlist.map((e) => e.toJson()).toList());

    await file.writeAsString(json);

    return searchlist;
  }

  Future<List> writeCategoryFile() async {
    final List<Category> catList = categories;
    File file = await _catFile;
    var json = jsonEncode(catList.map((e) => e.toJson()).toList());

    await file.writeAsString(json);

    return catList;
  }
}

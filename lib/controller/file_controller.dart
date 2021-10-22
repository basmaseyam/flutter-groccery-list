import 'package:flutter/material.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/item.dart';

class FileController extends ChangeNotifier {
  String _text;
  Item _itemslist;

  String get text => _text;
  Item get item => _itemslist;

  readText() async {
    _text = await FileManager().readTextFile();
    notifyListeners();
  }

  writeText() async {
    _text = await FileManager().writeTextFile();
    notifyListeners();
  }

  readUser() async {
    _itemslist = Item.fromJson(await FileManager().readJsonFile());
    notifyListeners();
  }


  // hashed by aya
/*  writeUser() async {
    _itemslist = await FileManager().writeJsonFile();
    notifyListeners();
  }*/
}

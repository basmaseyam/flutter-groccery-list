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

  readCart() async {
    final result = await FileManager().readJsonFile();

    if (result != null) {
      _itemslist = Item.fromJson(await FileManager().readJsonFile());
    }

    notifyListeners();
  }

<<<<<<< Updated upstream

  // hashed by aya
/*  writeUser() async {
    _itemslist = await FileManager().writeJsonFile();
=======
  writeCart() async {
    _itemslist = (await FileManager().writeJsonFile()) as Item;
>>>>>>> Stashed changes
    notifyListeners();
  }*/
}

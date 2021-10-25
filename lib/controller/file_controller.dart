import 'package:flutter/material.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/item.dart';

class FileController extends ChangeNotifier {
  String _text;
  List<dynamic> _itemslist;

  String get text => _text;
  List<Item> get cartitems => _itemslist;

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
      _itemslist = await FileManager().readJsonFile();
    }
    notifyListeners();
  }

  writeCart() async {
    _itemslist = await FileManager().writeJsonFile();

    notifyListeners();
  }
}

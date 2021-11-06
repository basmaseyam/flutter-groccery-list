import 'package:flutter/material.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';

class FileController extends ChangeNotifier {
  String _text;
  List _itemslist;
  List _catList;

  String get text => _text;
  List get cartitems => _itemslist;
  List get categorylist => _catList;

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
      _itemslist = result.map((e) => Item.fromJson(e)).toList();
    }
    notifyListeners();
  }

  readCategory() async {
    final result = await FileManager().readCategoryFile();

    if (result != null) {
      _catList = result.map((e) => Category.fromJson(e)).toList();
    }
    notifyListeners();
  }

  writeCart() async {
    _itemslist = await FileManager().writeJsonFile();

    notifyListeners();
  }

  writeCategory() async {
    _catList = await FileManager().writeCategoryFile();

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';

class FileController extends ChangeNotifier {
  String _text;
  List _itemslist;
  List _categories;

  String get text => _text;
  List get cartitems => _itemslist;
  List get categories => _categories;

  readCart() async {
    final result = await FileManager().readJsonFile();

    if (result != null) {
      _itemslist = result.map((e) => Item.fromJson(e)).toList();
    }
    notifyListeners();
  }

  writeCart() async {
    await FileManager().writeJsonFile();

    notifyListeners();
  }
}

import 'package:flutter/widgets.dart';

class Category extends ChangeNotifier {
  String category;

  List<Category> _categorys = [];

  void add(Category category) {
    _categorys.add(category);
    notifyListeners();
  }

  void remove(Category category) {
    _categorys.remove(category);
    notifyListeners();
  }

  Category({this.category});
}

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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(category: json["category"]);
  }
  Map<String, dynamic> toJson() => {
        "category": category,
      };
}

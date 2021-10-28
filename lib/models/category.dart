import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/controller/file_controller.dart';

class Category extends ChangeNotifier {
  String category;

  List<Category> _categorys = [];

  void add(Category category) {
    _categorys.add(category);
    FileController().writeCart();
    notifyListeners();
  }

  void remove(Category category) {
    _categorys.remove(category);
    FileController().writeCart();
    notifyListeners();
  }

  Category({this.category});
}

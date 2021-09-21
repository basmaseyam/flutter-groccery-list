import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/models/item.dart';

class Cart extends ChangeNotifier {
  List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  int get count {
    return _items.length;
  }

  List<Item> get basketItems {
    return _items.toSet().toList();
  }
}

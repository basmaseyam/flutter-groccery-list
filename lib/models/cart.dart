import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/models/item.dart';

class Cart extends ChangeNotifier {
  List<Item> _items = [];
  List<Item> _organizedItems = [];
  int counter = 0;
  List<Item> distinctIds = [];

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void delete(Item selectedItem) {
    _items.removeWhere((item) => selectedItem.title == item.title);
    notifyListeners();
  }

  int get count {
    distinctIds = _items.toSet().toList();
    return distinctIds.length;
  }

  List<Item> get basketItems {
    _organizedItems = _items.toSet().toList();
    _organizedItems.sort((a, b) => b.category.compareTo(a.category));
    return _organizedItems;
  }
}

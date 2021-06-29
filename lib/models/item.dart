import 'package:flutter/widgets.dart';

class Item extends ChangeNotifier {
  String title;
  String itemIcon;
  String category;
  String quantity;
  int amount;

  List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void incrementCounter() {
    amount++;
    notifyListeners();
  }

  void decrementCounter() {
    if (amount != 0) {
      amount--;
      notifyListeners();
    }
  }

  Item({this.title, this.itemIcon, this.category, this.amount, this.quantity});
}

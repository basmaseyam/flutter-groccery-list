import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/controller/file_controller.dart';

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

  void delete(Item selectedItem) {
    _items.removeWhere((item) => selectedItem.title == item.title);
    notifyListeners();
  }

  void decrementCounter() {
    if (amount != 0) {
      amount--;
    }

    notifyListeners();
  }

  bool get check {
    return false;
  }

  Item({
    this.title,
    this.itemIcon,
    this.category,
    this.amount,
    this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        title: json["title"],
        category: json["category"],
        quantity: json["quantity"],
        itemIcon: json["itemIcon"],
        amount: json["amount"]);
  }
  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "quantity": quantity,
        "itemIcon": itemIcon,
        "amount": amount
      };
}

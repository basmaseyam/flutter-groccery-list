import 'package:flutter/widgets.dart';
import 'package:moshtryate_new/controller/file_controller.dart';

class Item extends ChangeNotifier {
  String title;
  String itemIcon;
  String category;
  String quantity;
  int keyShow = 1;
  int amount;

  List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    FileController().writeCart();
    notifyListeners();
  }

  void remove(Item item) {
    // _items.remove(item);
    keyShow = 0;
    FileController().writeCart();
    notifyListeners();
  }

  void incrementCounter() {
    amount++;
    FileController().writeCart();
    notifyListeners();
  }

  void delete(Item selectedItem) {
    //_items.removeWhere((item) => selectedItem.title == item.title);
    selectedItem.keyShow = 0;
    FileController().writeCart();

    notifyListeners();
  }

  void decrementCounter() {
    if (amount != 0) {
      amount--;
      FileController().writeCart();
    }

    notifyListeners();
  }

  bool get check {
    return false;
  }

  Item(
      {this.title,
      this.itemIcon,
      this.category,
      this.amount,
      this.quantity,
      this.keyShow = 1});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        title: json["title"],
        category: json["category"],
        quantity: json["quantity"],
        itemIcon: json["itemIcon"],
        amount: json["amount"],
        keyShow: json["keyShow"]);
  }
  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "quantity": quantity,
        "itemIcon": itemIcon,
        "amount": amount,
        "keyShow": keyShow
      };
}

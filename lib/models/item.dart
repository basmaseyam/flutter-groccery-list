import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject with ChangeNotifier {
  @HiveField(0)
  String title;
  @HiveField(1)
  String itemIcon;
  @HiveField(2)
  String category;
  @HiveField(3)
  String quantity;
  @HiveField(4)
  int keyShow = 1;
  @HiveField(5)
  int bought = 0;
  @HiveField(6)
  int search = 1;
  @HiveField(7)
  int amount;

  List<Item> _items = [];

  void add(Item item) {
    _items.add(item);
    //FileController().writeCart();
    notifyListeners();
  }

  void show(Item item) {
    item.keyShow = 1;
    // FileController().writeCart();
    notifyListeners();
  }

  void remove() {
    // _items.remove(item);
    this.keyShow = 0;
    notifyListeners();
  }

  void hide() {
    // _items.remove(item);
    this.keyShow = 0;
    //FileController().writeCart();
    notifyListeners();
  }

  void incrementCounter() {
    this.amount++;
    //FileController().writeCart();

    notifyListeners();
  }

  void decrementCounter() {
    if (amount != 0) {
      amount--;
      // FileController().writeCart();
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
      this.keyShow = 1,
      this.bought = 0,
      this.search});

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

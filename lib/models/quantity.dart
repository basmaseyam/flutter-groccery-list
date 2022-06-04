import 'package:flutter/widgets.dart';

class Quantity extends ChangeNotifier {
  List<String> quantity;
  String category;

  List<Quantity> _quantities = [];

  List<dynamic> getSelectedQuantity(cat) {
    Iterable<Quantity> selectedquantity =
        _quantities.where((category) => category == cat);
    return selectedquantity.first.quantity;
  }

  Quantity({this.category, this.quantity});
}

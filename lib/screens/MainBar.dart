import 'package:flutter/material.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/screens/NewCategory.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/checkout.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'NewItem.dart';
import 'checkout.dart';
import 'package:moshtryate_new/widgets/searchbar.dart';

class MainBar extends StatefulWidget {
  final BuildContext context;
  final Cart cart;
  final Widget child;

  const MainBar({this.context, this.cart, this.child});

  @override
  _MainBarState createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  @override
  Widget build(context) {
    var dropdownvalue = 'item';

    return AppBar(
      titleSpacing: -8,
      title: Text(
        "مشترياتي",
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Vibes',
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Row(children: [
          // a row for + and cart icon at appbar
          DropdownButton(
            underline: Container(color: Colors.transparent),
            icon: Icon(
              Icons.add,
              size: 32,
            ),
            iconEnabledColor: Colors.white,
            iconSize: 32,
            value: 'item',
            items: <String>['item', 'category']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.centerEnd,
                  value: value,
                  child: value == 'item'
                      ? Text(
                          'إضافة منتج',
                          style: TextStyle(color: kMainColor),
                          textAlign: TextAlign.right,
                        )
                      : Text(
                          'إضافة قائمة',
                          style: TextStyle(color: kMainColor),
                          textAlign: TextAlign.right,
                        ),
                  onTap: () {
                    value == 'item'
                        ? Navigator.of(widget.context).push(
                            MaterialPageRoute(builder: (context) => NewItem()))
                        : Navigator.of(widget.context).push(MaterialPageRoute(
                            builder: (context) => NewCategory()));
                  });
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                dropdownvalue = newValue;
                print(dropdownvalue);
              });
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Row(
              children: [
                IconButton(
                  icon: Image(
                    image:
                        AssetImage('images/icons/icons8-shopping-cart-60.png'),
                  ),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CheckoutPage()));
                  },
                ),
                Text(
                  widget.cart.count.toString(),
                ),
              ],
            ),
          ),
        ])
      ],
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              //  prefixIcon: Icon(Icons.search),    // to add search icon before text
              filled: true,
              border: OutlineInputBorder(),
              hintText: 'البحث عن منتج',
              fillColor: Colors.white,
              focusColor: Colors.white,
            ),
            onTap: () {
              showSearch(
                context: context,
                delegate: Searchbar(),
                query: '',
              );
            },
          ),
        ),
        preferredSize: Size(0, 70.0),
      ),
    );
  }
}

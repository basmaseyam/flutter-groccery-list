import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/screens/NewCategory.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/homepage.dart';
import 'package:moshtryate_new/widgets/searchbar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/main.dart';

import 'drawer.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool firstvalue = false;
  var dropdownvalue = 'item';
  List<Item> boughtgoods;

  @override
  Widget build(BuildContext context) {
    List allItems = itemsBox.values.where((p) => p.keyShow == 1).toList();
    categories = categoriesBox.values.where((p) => p.keyShow == 1).toList();
    return Consumer<Cart>(builder: (context, cart, child) {
      List boughtItems = allItems.where((p) => p.bought == 1).toList();
      ScrollController _controller = new ScrollController();
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: -8,
            title: Text(
              'قائمة التسوق',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                //  fontFamily: 'Vibes',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
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
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewItem()))
                            : Navigator.of(context).push(MaterialPageRoute(
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
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  String list = '';
                  cart.basketItems.forEach((item) {
                    list += item.title;
                    list += ': ${item.amount} ${item.quantity}';
                    list += '\n';
                  });
                  Share.share(list, subject: "Grocery List");
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
            bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 11),
                child: TextField(
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 10),
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
          ),
          drawer: MyDrawer(),
          body: Stack(
            children: [
              cart.basketItems.length == 0
                  ? Center(
                      child: Text('لا توجد مشتريات',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)))
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 75),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String cat = categories[index].category;
                        List selectedItems = cart.basketItems
                            .where((p) => p.category.contains(cat))
                            .toList();
                        selectedItems
                            .sort((a, b) => a.title.compareTo(b.title));

                        return selectedItems.length != 0
                            ? ExpansionTile(
                                backgroundColor: Colors.grey[200],
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ),
                                title: Text(
                                  cat,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                initiallyExpanded: true,
                                children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: selectedItems.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          color: Colors.grey[100],
                                          child: ListTile(
                                            leading: IconButton(
                                              icon: Icon(
                                                Icons.check_box,
                                                size: 32,
                                              ),
                                              color: Colors.blue,
                                              onPressed: () {
                                                setState(() {
                                                  cart.delete(
                                                      selectedItems[index]);
                                                  selectedItems[index].save();
                                                });
                                              },
                                            ),
                                            title: Row(
                                              children: [
                                                ClipRect(
                                                    child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.asset(
                                                      selectedItems[index]
                                                          .itemIcon),
                                                )),
                                                SizedBox(width: 8),
                                                Text(
                                                    selectedItems[index].title),
                                                SizedBox(width: 16),
                                                Text(
                                                    '${selectedItems[index].amount}'
                                                    '   '
                                                    '${selectedItems[index].quantity}'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ])
                            : SizedBox(
                                width: 60,
                              );
                      },
                    ),
              Container(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _controller,
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    leading: Icon(
                      Icons.shopping_basket,
                      color: kMainColor,
                      size: 32,
                    ),
                    title: Text(
                      "ما تم شراؤه",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: boughtItems.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  background: Container(
                                    color: Colors.grey[200],
                                  ),
                                  key: ValueKey<Item>(boughtItems[index]),
                                  direction: DismissDirection.startToEnd,
                                  onDismissed: (direction) {
                                    setState(() {
                                      boughtItems[index].bought = 0;
                                      boughtItems[index].save();
                                    });
                                  },
                                  child: Card(
                                    color: Colors.grey[300],
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          ClipRect(
                                              child: Container(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(
                                                boughtItems[index].itemIcon),
                                          )),
                                          SizedBox(width: 8),
                                          Text(boughtItems[index].title,
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                          SizedBox(width: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

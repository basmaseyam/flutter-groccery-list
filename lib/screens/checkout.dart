import 'package:flutter/material.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
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

import 'drawer.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool firstvalue = false;
  var dropdownvalue = 'item';
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
          body: cart.basketItems.length == 0
              ? Center(
                  child: Text('لا توجد مشتريات',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String cat = categories[index].category;
                    List selectedItems = cart.basketItems
                        .where((p) => p.category.contains(cat))
                        .toList();
                    selectedItems.sort((a, b) => a.title.compareTo(b.title));
                    return selectedItems.length != 0
                        ? ExpansionTile(
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.transparent,
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
                                            cart.delete(selectedItems[index]);
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  selectedItems[index]
                                                      .itemIcon),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            SizedBox(width: 8),
                                            Text(selectedItems[index].title),
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
                            width: 12,
                          );
                  },
                ),
        ),
      );
    });
  }
}

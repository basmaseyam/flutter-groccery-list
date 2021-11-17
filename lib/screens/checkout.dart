import 'package:flutter/material.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/screens/homepage.dart';
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

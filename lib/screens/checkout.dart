import 'package:flutter/material.dart';
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
              title: Text('قائمة التسوق'),
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
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)))
                : ListView.builder(
                    itemCount: cart.basketItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.check_box),
                            color: Colors.blue,
                            onPressed: () {
                              cart.delete(cart.basketItems[index]);
                            },
                          ),
                          title: Row(
                            children: [
                              CircleAvatar(
                                  backgroundImage: AssetImage(
                                      cart.basketItems[index].itemIcon)),
                              SizedBox(width: 8),
                              Text(cart.basketItems[index].title),
                              SizedBox(width: 16),
                              Text('${cart.basketItems[index].amount}'
                                  '   '
                                  '${cart.basketItems[index].quantity}'),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
      );
    });
  }
}

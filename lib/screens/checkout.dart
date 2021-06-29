import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.menu),
              title: Text('قائمه التسوق'),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
            body: cart.basketItems.length == 0
                ? Text('لا يوجد مشتريات ')
                : ListView.builder(
                    itemCount: cart.basketItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            children: [
                              Image(
                                  image: AssetImage(
                                      cart.basketItems[index].itemIcon)),
                              SizedBox(width: 8),
                              Text(cart.basketItems[index].title),
                              Text('${cart.basketItems[index].quantity}''   '
                                  '${cart.basketItems[index].amount}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              cart.remove(cart.basketItems[index]);
                            },
                          ),
                        ),
                      );
                    },
                  )),
      );
    });
  }
}

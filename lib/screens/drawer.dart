import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/checkout.dart';
import 'homepage.dart';
import 'login.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('images/icons/moshtryate.png'),
          ),
          accountName: Text('مشترياتي'),
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            title: Text('الصفحة الرئيسية'),
            subtitle: Text('جميع المنتجات'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('قائمة التسوق'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutPage()));
            },
          ),
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            title: Text(
              'بحث او إضافه منتج',
            ),
            leading: Icon(Icons.add_shopping_cart_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewItem()));
            },
          ),
        ),
      ],
    ));
  }
}

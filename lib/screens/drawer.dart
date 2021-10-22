import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/checkout.dart';
import 'homepage.dart';
import 'about.dart';
import 'login.dart';

class MyDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: user != null
                ? NetworkImage(user.photoURL)
                : AssetImage('images/icons/icons8-happy-64.png'),
          ),
          accountName: user != null
              ? Text(
                  user.displayName,
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 25,
                  ),
                )
              : Text(
                  'لا يوجد اتصال بالانترنت',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 25,
                  ),
                ),
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
              'بحث و إضافه منتج',
            ),
            leading: Icon(Icons.add_shopping_cart_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewItem()));
            },
          ),
        ),
        InkWell(          // aya , changed order
          child: // to make the menu clickable and action happens
          ListTile(
            title: Text(
              'المواقع',
            ),
            leading: Icon(Icons.link),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => About()));
            },
          ),
        ),

        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            title: Text(
              'خروج',
            ),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              if (GoogleSignInAccount != null) {
                signOutFromGoogle();
              } else {
                FirebaseAuth.instance.signOut();
              }
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
      ],
    ));
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

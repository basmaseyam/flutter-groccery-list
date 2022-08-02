import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moshtryate_new/screens/NewCategory.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/checkout.dart';
import 'package:moshtryate_new/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                : AssetImage("images/icons/icons8-happy-64.png"),
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
                  preferences.getString('displayName'),
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 25,
                  ),
                ),
          accountEmail: null,
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            minLeadingWidth: 10,
            title: Text('الصفحة الرئيسية', style: TextStyle(fontSize: 18)),
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
            minLeadingWidth: 10,
            leading: Icon(Icons.shopping_cart),
            title: Text(
              'قائمة التسوق',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CheckoutPage()));
            },
          ),
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            minLeadingWidth: 10,
            title: Text(
              'بحث و إضافة منتج',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(Icons.add_shopping_cart_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewItem()));
            },
          ),
        ),
        InkWell(
          child: // to make the menu clickable and action happens
              ListTile(
            minLeadingWidth: 10, //aya
            title: Text(
              'إضافة قائمة',
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(Icons.add_shopping_cart_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewCategory()));
            },
          ),
        ),
        InkWell(
          // aya , changed order
          child: // to make the menu clickable and action happens
              ListTile(
            minLeadingWidth: 10,
            title: Text(
              'المواقع',
              style: TextStyle(fontSize: 18),
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
            minLeadingWidth: 10,
            title: user != null
                ? Text(
                    'خروج',
                    style: TextStyle(fontSize: 18),
                  )
                : Text(
                    'تسجيل دخول',
                    style: TextStyle(fontSize: 18),
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

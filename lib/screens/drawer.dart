import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moshtryate_new/screens/NewItem.dart';
import 'package:moshtryate_new/screens/checkout.dart';
import 'homepage.dart';
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
            backgroundImage: NetworkImage(user.photoURL),
          ),
          accountName: Text(
            user.displayName,
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
              'بحث او إضافه منتج',
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

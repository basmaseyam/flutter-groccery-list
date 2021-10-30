import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moshtryate_new/constants.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: kMainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/icons/moshtryate.png'),
            ),
            Text(
              'مشترياتي',
              style: TextStyle(
                fontFamily: 'Vibes',
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Container(
                height: 50,
                width: 230,
                child: SignInButton(
                  Buttons.Google,
                  shape: BeveledRectangleBorder(),
                  onPressed: () async {
                    await signInWithGoogle();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Container(
                height: 50,
                width: 230,
                child: SignInButton(
                  Buttons.Facebook,
                  onPressed: () async {
                    await signInWithFacebook();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final userCredential = await signInWithCredential(authCredential);
      User user = userCredential.user;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', user.email);
      if (user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (error) {
      return showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            });

            return AlertDialog(
              // aya , added icon to alertdialog
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                  ),
                  Text(
                    'لا يوجد اتصال بالانترنت',
                    // textAlign: TextAlign.center,
                  ),
                  Icon(Icons.offline_bolt, color: Colors.blueAccent),
                ],
              ),
            );
          });
      ;
    }
  }

  Future<Resource> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken.token);
          final userCredential =
              await _auth.signInWithCredential(facebookCredential);
          return Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        case LoginStatus.cancelled:
          return Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);
}

class Resource {
  final Status status;
  Resource({this.status});
}

enum Status { Success, Error, Cancelled }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await signInWithGoogle();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SignInButton(
                Buttons.Facebook,
                onPressed: () {},
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
      if (user != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (error) {
      print(error);
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logout() => _auth.signOut();

  Stream<User> get currentUser => _auth.authStateChanges();
}

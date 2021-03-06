import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/screens/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/cart.dart';
import 'screens/login.dart';

bool isloggedin = false;
bool isconnected = false;
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final preferences = await SharedPreferences.getInstance();
  final connectivity = await Connectivity().checkConnectivity();
  var email = preferences.getString('email');
  isconnected = connectivity == null ? false : true;
  isloggedin = email == null ? false : true;
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: (isloggedin || !isconnected) ? HomePage() : LoginScreen(),
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            HomePage.id: (context) => HomePage(),
          },
        ));
  }
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/screens/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/screens/login.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'models/cart.dart';
import 'screens/login.dart';
import 'package:hive/hive.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isloggedin = false;
bool isconnected = false;
Box itemsBox, categoriesBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(CategoryAdapter());
  itemsBox = await Hive.openBox<Item>('shopping_box');
  categoriesBox = await Hive.openBox<Category>('categories_box');

  await Firebase.initializeApp();

  final preferences = await SharedPreferences.getInstance();
  final connectivity = await Connectivity().checkConnectivity();
  var email = preferences.getString('email');
  isconnected = connectivity == null ? false : true;
  isloggedin = email == null ? false : true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        //ChangeNotifierProvider(
        //  create: (context) => FileController(),
        // ),
      ],
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
          home: AnimatedSplashScreen(
            duration: 3000,
            splash: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image(
                image: AssetImage('images/icons/basket2.png'),
                alignment: Alignment.center,
              ),
            ),
            nextScreen:
                (isloggedin || !isconnected) ? HomePage() : LoginScreen(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: kMainColor,
          ),
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            HomePage.id: (context) => HomePage(),
          },
        ));
  }
}

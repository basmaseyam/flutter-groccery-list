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
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'models/cart.dart';
import 'screens/login.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isloggedin = false;
bool isconnected = false;
Box itemsBox, categoriesBox;
var preferences;
File newImage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(CategoryAdapter());
  itemsBox = await Hive.openBox<Item>('shopping_box');
  categoriesBox = await Hive.openBox<Category>('categories_box');

  await Firebase.initializeApp();

  preferences = await SharedPreferences.getInstance();
  final connectivity = await Connectivity().checkConnectivity();
  var email = preferences.getString('email');

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  /*var imageURL = await preferences.getString('photoURL');
  // using your method of getting an image
  final File image = File(imageURL);
// copy the file to a new path
  newImage = await image.copy('$dir/image1.png');*/

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
      child: MyApp(showHome: showHome),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({
    Key key,
    this.showHome,
  }) : super(key: key);
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
              nextScreen: showHome ? HomePage() : OnBoardingPage(),
              splashTransition: SplashTransition.scaleTransition,
              backgroundColor: kMainColor,
            ),
            routes: {
              LoginScreen.id: (context) => LoginScreen(),
              HomePage.id: (context) => HomePage()
            }));
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 1;
            });
          },
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 200,
                    width: 300,
                    image: AssetImage('images/slider/edited.png'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'مشترياتي',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('تطبيق يساعدك في شراء احتياجاتك من السوق',
                      style: TextStyle(color: Colors.black26, fontSize: 16)),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 200,
                    width: 300,
                    image: AssetImage('images/slider/46271.png'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'مشترياتي',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('يساعدك بالاستمتاع بالشراء دون ان تنسي شيئا',
                      style: TextStyle(color: Colors.black26, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                primary: Colors.white,
                backgroundColor: kMainColor,
                minimumSize: const Size.fromHeight(80),
              ),
              child: Text(
                'ابدأ',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: ((context) => LoginScreen()),
                ));
              })
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(2);
                      },
                      child: Text('SKIP')),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 2,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: kMainColor,
                      ),
                      onDotClicked: (index) {
                        controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Text('NEXT'))
                ],
              ),
            ),
    );
  }
}

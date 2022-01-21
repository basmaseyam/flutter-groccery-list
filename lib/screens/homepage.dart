import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/screens/NewCategory.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moshtryate_new/ad_helper.dart';

//import 'package:moshtryate_new/screens/About.dart';

import 'NewItem.dart';
import 'checkout.dart';
import 'drawer.dart';
import 'MainBar.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  final List<Item> itemsothers = [];

  int amount = 0;
  final List<String> quantities = [
    'جرام',
    'لتر',
    'كيلو',
    'عبوة',
    'وحدة',
    'حزمة'
  ];

  @override
  void initState() {
    if (FileManager().readJsonFile() == null) {
      context.read<FileController>().writeCart();
    }
    if (FileManager().readCategoryFile() == null &&
        FileManager().readJsonFile() != null) {
      context.read<FileController>().writeCategory();
    }

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    items = context.select((FileController controller) =>
        controller.cartitems != null
            ? controller.cartitems.where((p) => p.keyShow == 1).toList()
            : items.where((p) => p.keyShow == 1).toList());
    categories = context.select((FileController controller) =>
        controller.categorylist != null
            ? controller.categorylist.where((p) => p.keyShow == 1).toList()
            : categories.where((p) => p.keyShow == 1).toList());
    List itemsCats = items;

    return Consumer<Cart>(builder: (context, cart, child) {
      if (cart.count == 0)
        cart.addAll(context
            .select(
                (FileController controller) => items.where((p) => p.amount > 0))
            .toList());

      return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "مشترياتي",
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: PreferredSize(
                  child: MainBar(context: context, cart: cart, child: child),
                  preferredSize: Size.fromHeight(120)),
              drawer: MyDrawer(),
              body: FutureBuilder<void>(
                  future: _initGoogleMobileAds(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return Stack(children: [
                      ListView.builder(
                          padding:
                              EdgeInsets.only(top: _isBannerAdReady ? 75 : 0),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            String cat = categories[index].category;
                            List selectedItems = itemsCats
                                .where((p) => p.category.contains(cat))
                                .toList();
                            selectedItems
                                .sort((a, b) => a.title.compareTo(b.title));

                            return Slidable(
                                direction: Axis.horizontal,
                                actionPane: SlidableScrollActionPane(),
                                child: ExpansionTile(title: Text(cat),
                                    //    trailing: Icon(Icons.keyboard_arrow_left),
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: selectedItems.length,
                                        itemBuilder: (context, index) {
                                          var dropdownvalue =
                                              selectedItems[index].quantity;
                                          return Card(
                                            color: Colors.grey[100],
                                            child: Slidable(
                                              direction: Axis.horizontal,
                                              actionPane:
                                                  SlidableScrollActionPane(),
                                              child: ListTile(
                                                title: Text(
                                                    selectedItems[index].title),
                                                leading: ClipRect(
                                                    //   backgroundColor: Colors.transparent,

                                                    child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: Image.asset(
                                                      selectedItems[index]
                                                          .itemIcon),
                                                )),
                                                trailing: Flex(
                                                  direction: Axis.horizontal,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        icon:
                                                            Icon(Icons.add_box),
                                                        iconSize: 32,
                                                        color: Colors.blue,
                                                        onPressed: () {
                                                          selectedItems[index]
                                                              .incrementCounter();

                                                          return cart.add(
                                                              selectedItems[
                                                                  index]);
                                                        }),
                                                    Text(
                                                        '${selectedItems[index].amount}'),
                                                    IconButton(
                                                        icon: Image(
                                                          image: AssetImage(
                                                              'images/icons/2-.png'),
                                                        ),
                                                        onPressed: () {
                                                          selectedItems[index]
                                                              .decrementCounter();

                                                          return cart.remove(
                                                              selectedItems[
                                                                  index]);
                                                        }),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      constraints:
                                                          BoxConstraints.tight(
                                                              Size.fromWidth(
                                                                  60)),
                                                      child: DropdownButton(
                                                        underline: Container(
                                                            color: Colors
                                                                .transparent),
                                                        value: dropdownvalue,
                                                        items: quantities.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                                  String>(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerEnd,
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                              onTap: () {
                                                                selectedItems[
                                                                            index]
                                                                        .quantity =
                                                                    value;
                                                              });
                                                        }).toList(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            dropdownvalue =
                                                                newValue;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {},
                                              ),
                                              secondaryActions: [
                                                IconSlideAction(
                                                  caption: 'حذف',
                                                  color: Colors.black45,
                                                  icon: Icons.delete,
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                3, 0, 3, 0),
                                                        child: AlertDialog(
                                                            // aya , translated buttons text
                                                            title: const Text(
                                                              'هل تريد حذف المنتج ؟',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            actions: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        3,
                                                                        0,
                                                                        3,
                                                                        0),
                                                                child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Cancel'),
                                                                          child:
                                                                              const Text('لا'),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context,
                                                                                'Ok');
                                                                            setState(() {
                                                                              selectedItems[index].keyShow = 0;
                                                                              cart.delete(selectedItems[index]);
                                                                              FileController().writeCart();
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text('نعم'),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ]),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'حذف',
                                    color: Colors.black45,
                                    icon: Icons.delete,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 0, 3, 0),
                                          child: AlertDialog(
                                            // aya , translated buttons text
                                            title: const Text(
                                              'هل تريد حذف القائمه ؟',
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        3, 0, 3, 0),
                                                child: Row(children: [
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: const Text('لا'),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Ok');
                                                        if (selectedItems
                                                                .length ==
                                                            0) {
                                                          setState(() {
                                                            categories[index]
                                                                .remove();
                                                            FileController()
                                                                .writeCategory();
                                                          });
                                                        } else {
                                                          return showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                Future.delayed(
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              HomePage()));
                                                                });

                                                                return AlertDialog(
                                                                  // aya , added icon to alertdialog
                                                                  title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'برجاء حذف محتويات القائمه اولا',
                                                                        // textAlign: TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        }
                                                      },
                                                      child: const Text('نعم'),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ]);
                          }),
                      if (_isBannerAdReady)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.white,
                            height: _bannerAd.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          ),
                        ),
                    ]);
                  }),
            ),
          ),
        ),
      );
    });
  }
}

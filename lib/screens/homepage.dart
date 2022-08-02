import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/main.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/quantity.dart';
import 'package:moshtryate_new/data/quantity.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  int amount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (itemsBox.isEmpty) {
      itemsBox.addAll(items);
    }

    if (categoriesBox.isEmpty) {
      categoriesBox.addAll(categories);
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd.dispose();
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List itemsCats =
        itemsBox.values.where((i) => i.keyShow == 1).toList().cast<Item>();
    List categories = categoriesBox.values
        .where((i) => i.keyShow == 1)
        .toList()
        .cast<Category>();
    return Consumer<Cart>(builder: (context, cart, child) {
      if (cart.count == 0) {
        final cartItems = itemsCats.where((i) => i.amount != 0).toList();
        cart.addAll(cartItems.cast<Item>());
      }
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
                                .where((p) => p.category == cat)
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

                                          List<String> selectedquantity = [];

                                          if (selectedItems[index].category ==
                                              'الفواكه و الخضار') {
                                            selectedquantity = [
                                              'كيلو1/4',
                                              '1/2كيلو',
                                              'كيلو',
                                              'وحدة',
                                              'حزمة',
                                              'عبوة'
                                            ];
                                          } else if (selectedItems[index]
                                                  .category ==
                                              'مستلزمات الطبخ') {
                                            selectedquantity = [
                                              '100جرام',
                                              '250جرام',
                                              '500جرام',
                                              'كيلو',
                                              'لتر',
                                              'عبوة',
                                              'وحدة',
                                              'حزمة'
                                            ];
                                          } else {
                                            selectedquantity = [
                                              'جرام',
                                              'لتر',
                                              'كيلو',
                                              'عبوة',
                                              'وحدة',
                                              'حزمة'
                                            ];
                                          }

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

                                                          cart.add(
                                                              selectedItems[
                                                                  index]);
                                                          selectedItems[index]
                                                              .save();
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
                                                          selectedItems[index]
                                                              .save();
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
                                                                  90)),
                                                      child: DropdownButton(
                                                        underline: Container(
                                                            color: Colors
                                                                .transparent),
                                                        value: dropdownvalue,
                                                        items: selectedquantity.map<
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
                                                            selectedItems[index]
                                                                .save();
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
                                                    hideProduct(
                                                        context,
                                                        selectedItems,
                                                        index,
                                                        cart);
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
                                                            categories[index]
                                                                .save();
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

  void hideProduct(
      BuildContext context, List<dynamic> selectedItems, int index, Cart cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: AlertDialog(
            // aya , translated buttons text
            title: const Text(
              'هل تريد حذف المنتج ؟',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                child: Row(children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('لا'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Ok');
                        setState(() {
                          selectedItems[index].keyShow = 0;
                          selectedItems[index].amount > 0
                              ? cart.delete(selectedItems[index])
                              : selectedItems[index].hide();
                          selectedItems[index].save();
                        });
                      },
                      child: const Text('نعم'),
                    ),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}

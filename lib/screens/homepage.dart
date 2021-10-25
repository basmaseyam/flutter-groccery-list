import 'dart:io';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moshtryate_new/constants.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/screens/NewCategory.dart';
import 'package:provider/provider.dart';
//import 'package:moshtryate_new/screens/About.dart';

import 'NewItem.dart';
import 'checkout.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> itemsothers = [];

  int amount = 0;
  var dropdownvalue = 'item';

  @override
  Widget build(BuildContext context) {
    List itemsCats = context.select(
      (FileController controller) =>
          controller.cartitems != null ? controller.cartitems : [],
    );

    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "مشترياتي",
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Text(
                  "مشترياتي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Vibes',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  Row(children: [
                    // a row for + and cart icon at appbar
                    DropdownButton(
                      underline: Container(color: Colors.transparent),
                      icon: Icon(
                        Icons.add,
                        size: 32,
                      ),
                      iconEnabledColor: Colors.white,
                      iconSize: 32,
                      value: 'item',
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                      items: <String>['item', 'category']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: value == 'item'
                                ? Text(
                                    'إضافة منتج',
                                    style: TextStyle(color: kMainColor),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    'إضافة قسم',
                                    style: TextStyle(color: kMainColor),
                                    textAlign: TextAlign.center,
                                  ),
                            onTap: () {
                              value == 'item'
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => NewItem()))
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => NewCategory()));
                            });
                      }).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image(
                              image: AssetImage(
                                  'images/icons/icons8-shopping-cart-60.png'),
                            ),
                            iconSize: 35,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckoutPage()));
                            },
                          ),
                          Text(
                            cart.count.toString(),
                          ),
                        ],
                      ),
                    ),
                  ])
                ],
                bottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 11),
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 10),
                        //  prefixIcon: Icon(Icons.search),    // to add search icon before text
                        filled: true,
                        border: OutlineInputBorder(),
                        /*                    icon: Icon(     //searcg icon
                          Icons.search,

                          color: Colors.white,
                        ),

     */ //updated
                        hintText: 'البحث عن منتج',
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                      ),
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: Searchbar(),
                          query: '',
                        );
                      },
                    ),
                  ),
                  preferredSize: Size(0, 70.0),
                ),
              ),
              drawer: MyDrawer(),
              body: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String cat = categories[index].category;
                  List selectedItems =
                      itemsCats.where((p) => p.category.contains(cat)).toList();
                  return ExpansionTile(title: Text(cat),
                      //    trailing: Icon(Icons.keyboard_arrow_left),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.grey[100],
                              child: Slidable(
                                direction: Axis.horizontal,
                                actionPane: SlidableScrollActionPane(),
                                child: ListTile(
                                  title: Text(selectedItems[index].title),
                                  leading: ClipRect(
                                      //   backgroundColor: Colors.transparent,

                                      child: Container(
                                    width: 40,
                                    height: 40,
                                    child: Image.asset(
                                        selectedItems[index].itemIcon),
                                  )),
                                  trailing: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.add_box),
                                          iconSize: 32,
                                          color: Colors.blue,
                                          onPressed: () {
                                            selectedItems[index]
                                                .incrementCounter();
                                            setState(() {
                                              FileController().writeCart();
                                            });
                                            return cart
                                                .add(selectedItems[index]);
                                          }),
                                      Text('${selectedItems[index].amount}'),
                                      IconButton(
                                          icon: Image(
                                            image: AssetImage(
                                                'images/icons/2-.png'),
                                          ),
                                          onPressed: () {
                                            selectedItems[index]
                                                .decrementCounter();
                                            setState(() {
                                              FileController().writeCart();
                                            });
                                            return cart
                                                .remove(selectedItems[index]);
                                          }),
                                      Container(
                                        alignment: Alignment.center,
                                        constraints: BoxConstraints.tight(
                                            Size.fromWidth(32)),
                                        child: Text(
                                          '${selectedItems[index].quantity}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                                secondaryActions: [
                                  IconSlideAction(
                                    caption: 'حذف',
                                    color: Colors.redAccent,
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
                                                'هل تريد حذف المنتج ؟',
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          3, 0, 3, 0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child:
                                                              const Text('لا'),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, 'Ok');
                                                            setState(() {
                                                              items.remove(
                                                                  selectedItems[
                                                                      index]);
                                                              cart.delete(
                                                                  selectedItems[
                                                                      index]);
                                                            });
                                                          },
                                                          child:
                                                              const Text('نعم'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                      ]);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

class Searchbar extends SearchDelegate<Item> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Item> mylist = items;
    final Item result = mylist.where((p) => p.title.contains(query)).first;
    final _formKey = GlobalKey<FormState>();
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Card(
                  child: ListTile(
                title: Text(result.title),
                leading:
                    CircleAvatar(backgroundImage: AssetImage(result.itemIcon)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.blue,
                        onPressed: () {
                          result.incrementCounter();

                          return cart.add(result);
                        }),
                    Text('${result.amount}'),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.blue,
                        onPressed: () {
                          result.decrementCounter();

                          return cart.remove(result);
                        }),
                  ],
                ),
                onTap: () {
                  print('clicked');
                },
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف جديد'),
              ),
            ],
          ));
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Item> mylist = items;

    mylist = query.isEmpty
        ? mylist
        : mylist.where((p) => p.title.startsWith(query)).toList();

    return mylist.isEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "هذا المنتج غير موجود",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف منتج جديد'),
              ),
            ],
          ))
        : ListView.builder(
            itemCount: mylist.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    query = mylist[index].title;
                    return showResults(context);
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(mylist[index].itemIcon),
                  ),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mylist[index].title),
                        Text(mylist[index].category,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]));
            },
          );
  }
}

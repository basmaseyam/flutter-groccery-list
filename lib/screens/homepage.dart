import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
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
  final List<Item> itemsCats = items;

  final List<Item> itemsothers = [];

  int amount = 0;

  @override
  Widget build(BuildContext context) {
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
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewItem()));
                        }),
                    Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image(
                              image: AssetImage('images/icons/basket1.png'),
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
                  List<Item> selectedItems =
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
                            return Dismissible(
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.remove),
                              ),
                              key: ValueKey<Item>(selectedItems[index]),
                              onDismissed: (DismissDirection direction) {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title: const Text(
                                              'هل تريد حذف المنتج ؟'),
                                          actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, 'OK');
                                            setState(() {
                                              items
                                                  .remove(selectedItems[index]);
                                            });
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ]),
                                );
                              },
                              child: ListTile(
                                title: Text(selectedItems[index].title),
                                leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        selectedItems[index].itemIcon)),
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

                                          return cart.add(selectedItems[index]);
                                        }),
                                    Text('${selectedItems[index].amount}'),
                                    IconButton(
                                        icon: Image(
                                          image:
                                              AssetImage('images/icons/2-.png'),
                                        ),
                                        onPressed: () {
                                          selectedItems[index]
                                              .decrementCounter();

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
                                onLongPress: () {},
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

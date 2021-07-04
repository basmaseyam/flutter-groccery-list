import 'package:flutter/material.dart';
import 'package:moshtryate_new/data/baking.dart';
import 'package:moshtryate_new/data/dairies.dart';
import 'package:moshtryate_new/data/drinkies.dart';
import 'package:moshtryate_new/data/fruitsveggies.dart';
import 'package:moshtryate_new/data/grains.dart';
import 'package:moshtryate_new/data/meatfish.dart';
import 'package:moshtryate_new/data/spices.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:provider/provider.dart';

import 'NewItem.dart';
import 'checkout.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> itemsFruits = itemFruitsVeggies;
  final List<Item> itemsgrains = grains;
  final List<Item> itemsmeat = meatfish;
  final List<Item> itemsdrinkies = drinkies;
  final List<Item> itemsdairies = dairies;
  final List<Item> itemsbaking = baking;
  final List<Item> itemsspices = spices;
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
                    title: Text(
                      "مشترياتي",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Vibes',
                        fontSize: 25,
                      ),
                    ),
                    actions: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
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
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewItem()));
                            }),
                      ])
                    ],
                    bottom: PreferredSize(
                      child: Padding(
                        padding: const EdgeInsets.all(8.00),
                        child: TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(),
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintText: 'بحث',
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
                      preferredSize: Size(0.0, 70.0),
                    ),
                  ),
                  drawer: MyDrawer(),
                  body: ListView(children: <Widget>[
                    ExpansionTile(title: Text('الخضروات و الفواكهة'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsFruits.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsFruits[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsFruits[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsFruits[index].incrementCounter();

                                          return cart.add(itemsFruits[index]);
                                        }),
                                    Text('${itemsFruits[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsFruits[index].decrementCounter();

                                          return cart
                                              .remove(itemsFruits[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {},
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('اللحوم'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsmeat.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsmeat[index].title),
                                leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(itemsmeat[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsmeat[index].incrementCounter();

                                          return cart.add(itemsmeat[index]);
                                        }),
                                    Text('${itemsmeat[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsmeat[index].decrementCounter();

                                          return cart.remove(itemsmeat[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('الحبوب'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsgrains.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsgrains[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsgrains[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsgrains[index].incrementCounter();

                                          return cart.add(itemsgrains[index]);
                                        }),
                                    Text('${itemsgrains[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsgrains[index].decrementCounter();

                                          return cart
                                              .remove(itemsgrains[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('المشروبات'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsdrinkies.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsdrinkies[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsdrinkies[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsdrinkies[index]
                                              .incrementCounter();

                                          return cart.add(itemsdrinkies[index]);
                                        }),
                                    Text('${itemsdrinkies[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsdrinkies[index]
                                              .decrementCounter();

                                          return cart
                                              .remove(itemsdrinkies[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('الالبان'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsdairies.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsdairies[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsdairies[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsdairies[index]
                                              .incrementCounter();

                                          return cart.add(itemsdairies[index]);
                                        }),
                                    Text('${itemsdairies[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsdairies[index]
                                              .decrementCounter();

                                          return cart
                                              .remove(itemsdairies[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('المخبوزات'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsbaking.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsbaking[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsbaking[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsbaking[index].incrementCounter();

                                          return cart.add(itemsbaking[index]);
                                        }),
                                    Text('${itemsbaking[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsbaking[index].decrementCounter();

                                          return cart
                                              .remove(itemsbaking[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                    ExpansionTile(title: Text('التوابل'),
                        //    trailing: Icon(Icons.keyboard_arrow_left),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: itemsspices.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: ListTile(
                                title: Text(itemsspices[index].title),
                                leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        itemsspices[index].itemIcon)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.add),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsspices[index].incrementCounter();

                                          return cart.add(itemsspices[index]);
                                        }),
                                    Text('${itemsspices[index].amount}'),
                                    IconButton(
                                        icon: Icon(Icons.remove),
                                        color: Colors.blue,
                                        onPressed: () {
                                          itemsspices[index].decrementCounter();

                                          return cart
                                              .remove(itemsspices[index]);
                                        }),
                                  ],
                                ),
                                onTap: () {
                                  print('clicked');
                                },
                              ));
                            },
                          ),
                        ]),
                  ]),
                ),
              )));
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
    List<Item> mylist = itemFruitsVeggies +
        grains +
        meatfish +
        spices +
        baking +
        dairies +
        drinkies;
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
    List<Item> mylist = itemFruitsVeggies +
        grains +
        meatfish +
        spices +
        baking +
        dairies +
        drinkies;

    mylist = query.isEmpty
        ? mylist
        : mylist.where((p) => p.title.startsWith(query)).toList();

    return mylist.isEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "...لا يوجد المنتج ",
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
                child: const Text('اضف جديد'),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';
import '../data/baking.dart';
import '../data/dairies.dart';
import '../data/drinkies.dart';
import '../data/fruitsveggies.dart';
import '../data/grains.dart';
import '../data/meatfish.dart';
import '../data/spices.dart';
import '../models/cart.dart';
import 'drawer.dart';
import 'homepage.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final List<Item> itemsFruits = itemFruitsVeggies;
  final List<Item> itemsgrains = grains;
  final List<Item> itemsmeat = meatfish;
  final List<Item> itemsdrinkies = drinkies;
  final List<Item> itemsdairies = dairies;
  final List<Item> itemsbaking = baking;
  final List<Item> itemsspices = spices;
  final List<Item> itemsextra = [];
  final List<String> categories = [
    'الخضروات و الفواكهة',
    'اللحوم',
    'الحبوب',
    'المشروبات',
    'الالبان',
    'المخبوزات',
    'التوابل',
    'اخرى'
  ];

  List<DropdownMenuItem> _categories = [];

  Item newitem;
  final titleController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, item, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('اضف جديد'),
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text(
                'اضف جديد',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'الاسم')),
              TextField(
                  controller: categoryController,
                  decoration: InputDecoration(hintText: 'القسم')),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              if (newitem != []) {
                newitem.title = titleController.text;
                newitem.category = categoryController.text;
                newitem.itemIcon =
                    'images/icons/Bread&Bakeing/icons8-bread-48.png';
                newitem.amount = 1;
                if (newitem.category == 'فواكه و خضراوت')
                  itemsFruits.add(newitem);
                else if (newitem.category == 'مخبوزات')
                  itemsbaking.add(newitem);
                else if (newitem.category == 'منتجات البان')
                  itemsdairies.add(newitem);
                else if (newitem.category == 'حبوب')
                  itemsgrains.add(newitem);
                else if (newitem.category == 'لحوم و اسماك')
                  itemsmeat.add(newitem);
                else if (newitem.category == 'توابل')
                  itemsspices.add(newitem);
                else if (newitem.category == 'مشروبات')
                  itemsdrinkies.add(newitem);
                else {
                  itemsextra.add(newitem);
                }

                return Text('تم اضافه المنتج الي القائمه');
              } else {
                return Text('حاول مره اخري');
              }
            },
            tooltip: 'اضف الى القائمه',
            child: Icon(Icons.add),
          ),
        ),
      );
    });
  }
}

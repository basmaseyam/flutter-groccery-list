import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/widgets/searchbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import '../data/units.dart';
import '../models/cart.dart';
import '../models/category.dart';
import 'drawer.dart';
import 'homepage.dart';

class NewItem extends StatefulWidget {
  const NewItem({Key key}) : super(key: key);
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final List<Item> itemsextra = [];
  final List<String> _quantities = quantities;
  final List<Category> _categories = categories;

  Category chooseItem;

  var newitem = Item();

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final List<Item> itemsCat = context.select((FileController controller) =>
        controller.cartitems != null ? controller.cartitems : items);
    items = itemsCat;
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: -8,
            title: Text(
              'إضافة منتج',
              style: TextStyle(
                //  fontFamily: 'Vibes',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: FormBuilder(
              key: _formKey,
              child: ListView(children: [
                /* Text(
                  'إضافة منتج جديد',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                  ),
                ),*/ // commented by aya
                FormBuilderTextField(
                  name: 'title',
                  decoration: InputDecoration(hintText: 'اسم المنتج الجديد'),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                ),
                SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderDropdown(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    name: 'category',
                    decoration: InputDecoration(
                      filled: true, /* icon: Icon(Icons.category)*/
                    ), //Updated by aya , removed un necessary search icon
                    hint: Text('إختر القائمه المناسبه'),
                    isExpanded: true,
                    allowClear: true,
                    items: _categories.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem.category,
                          child: Text(valueItem.category));
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderDropdown(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    name: 'quantity',
                    decoration: InputDecoration(
                      filled: true, /*icon: Icon(Icons.ad_units)*/
                    ), //Updated by aya , removed un necessary icon
                    hint: Text('إختر الوحدة المناسبة'),
                    allowClear: true,
                    items: _quantities.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderChoiceChip(
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(context)]),
                    spacing: 8,
                    runSpacing: 8,
                    name: 'image',
                    decoration: InputDecoration(
                      labelText: 'اختر الصورة',
                    ),
                    options: [
                      FormBuilderFieldOption(
                        value: 'images/png/groceries.png',
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/groceries.png'),
                          ),
                        ),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/light-bulb.png',
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/light-bulb.png'),
                          ),
                        ),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/gingerbread.png',
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/gingerbread.png'),
                          ),
                        ),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/hazelnut.png',
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/hazelnut.png'),
                          ),
                        ),
                      ),
                      FormBuilderFieldOption(
                        value: 'images/png/pasta.png',
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/pasta.png'),
                          ),
                        ),
                      ),
                      FormBuilderFieldOption(
                        value:
                            'images/png/glass-3.png', //Updated by aya, wrong VALUE WAS GIVEN AS PASTA
                        child: ClipRect(
                          child: Container(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/png/glass-3.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                print(_formKey.currentState.value);

                newitem.title = _formKey.currentState.value['title'].toString();

                newitem.category =
                    _formKey.currentState.value['category'].toString();
                newitem.itemIcon =
                    _formKey.currentState.value['image'].toString();

                newitem.amount = 1;
                newitem.quantity =
                    _formKey.currentState.value['quantity'].toString();
                print(newitem.title);

                setState(() {
                  items.add(newitem);
                  newitem.keyShow = 1;
                  cart.add(newitem);
                  FileController().writeCart();
                  _formKey.currentState.reset();
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop(HomePage());
                      });

                      return AlertDialog(
                        // aya , added icon to alertdialog
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                            ),
                            Text(
                              'تمت إضافة المنتج',
                              // textAlign: TextAlign.center,
                            ),
                            Icon(Icons.check, color: Colors.blueAccent),
                          ],
                        ),
                      );
                    });
              } else {
                print('validation failed');
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

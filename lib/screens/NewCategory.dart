import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
import 'package:moshtryate_new/data/quantity.dart';
import 'package:moshtryate_new/file_manager.dart';
import 'package:moshtryate_new/models/quantity.dart';
import 'package:moshtryate_new/widgets/searchbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:provider/provider.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:moshtryate_new/models/cart.dart';
import '../data/itemscat.dart';
import '../models/cart.dart';
import '../models/category.dart';
import 'drawer.dart';
import 'homepage.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({Key key}) : super(key: key);
  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  Category chooseItem;

  var newcat = Category();

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: -8,
            title: Text(
              'إضافة قائمة',
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
                /*  Text(
                  'اضف قائمه جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),  */ // commented by aya . for better simpler view
                FormBuilderTextField(
                  name: 'category',
                  decoration: InputDecoration(hintText: 'اسم القائمه الجديدة'),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
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

                newcat.category =
                    _formKey.currentState.value['category'].toString();

                setState(() {
                  categories.add(newcat);

                  newcat.keyShow = 1;
                  FileController().writeCategory();
                  FileController().writeCart();
                  _formKey.currentState.reset();
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      });

                      return AlertDialog(
                        // aya , added icon to alertdialog
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                            ),
                            Text(
                              'تمت إضافة القائمه',
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

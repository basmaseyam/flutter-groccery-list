import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:moshtryate_new/controller/file_controller.dart';
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
            titleSpacing: 0,
            title: Text('اضف قسم جديد'),
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
            child: FormBuilder(
              key: _formKey,
              child: ListView(children: [
                Text(
                  'اضف قائمه جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                FormBuilderTextField(
                  name: 'category',
                  decoration: InputDecoration(hintText: 'اسم القائمه '),
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

                categories.add(newcat);

                setState(() {
                  _formKey.currentState.reset();
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 2), () {
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

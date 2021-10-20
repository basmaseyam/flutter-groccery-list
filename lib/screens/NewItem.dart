import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final List<Item> itemsCats = items;

  final List<Item> itemsextra = [];

  final List<Category> _categories = categories;
  final List<String> _quantities = ['لتر', 'كيلو', 'جرام', 'وحده'];
  Category chooseItem;

  Item newitem;

  final _formKey = GlobalKey<FormBuilderState>();

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
            child: FormBuilder(
              key: _formKey,
              child: Column(children: [
                Text(
                  'اضف جديد',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                FormBuilderTextField(
                  name: 'title',
                  decoration: InputDecoration(hintText: 'الاسم'),
                  enabled: true,
                ),
                SizedBox(
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilderDropdown(
                    name: 'category',
                    decoration: InputDecoration(
                        filled: true, icon: Icon(Icons.category)),
                    hint: Text('اختر القسم'),
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
                    name: 'quantity',
                    decoration: InputDecoration(
                        filled: true, icon: Icon(Icons.ac_unit)),
                    hint: Text('اختر الوحده'),
                    allowClear: true,
                    items: _quantities.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
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
                newitem.title =
                    _formKey.currentState.fields['title'].toString();
                newitem.category =
                    _formKey.currentState.fields['category'].toString();
                newitem.itemIcon = 'images\icons\groceries.png';
                newitem.amount = 1;
                newitem.quantity =
<<<<<<< Updated upstream
                    _formKey.currentState.fields['quantity'].toString();
                itemsCats.add(newitem);
=======
                    _formKey.currentState.value['quantity'].toString();
                print(newitem.title);
                cart.add(newitem);
                items.add(newitem);
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(
                          Duration(seconds: 3), () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      });
                      return AlertDialog(
                        title: Text('تمت إضافة المنتح',textAlign: TextAlign.center,),
                      );

                    }
                      /* =>AlertDialog(
                      title: const Text('تمت إضافة المنتح للقائمة', textAlign: TextAlign.center,),
                      content: Row(
                          children: <Widget>[
                          Expanded(

                            child: TextButton(

                            onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('إلغاء', textAlign: TextAlign.center,),


                        ),
                      ),

                       Expanded(
                         child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Ok');
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                    },
                                    child: const Text('موافقة', textAlign: TextAlign.center,),
                                  ),
                          ),
                            ]  ),),
*/

                );
>>>>>>> Stashed changes
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

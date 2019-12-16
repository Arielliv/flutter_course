import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/providers/item.dart';
import 'package:workshop1/widgets/inputs/image_input.dart';
import '../providers/items.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit-item';
  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();

  final _priceFocusNode = FocusNode();
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  var _editedItem = Item(
    id: null,
    title: '',
    price: 0,
    description: '',
    imagePath: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imagePath': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final itemId = ModalRoute.of(context).settings.arguments as String;
      if (itemId != null) {
        _editedItem =
            Provider.of<Items>(context, listen: false).findById(itemId);
        _initValues = {
          'title': _editedItem.title,
          'description': _editedItem.description,
          'price': _editedItem.price.toString(),
          'imagePath': '',
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedItem.id != null) {
      await Provider.of<Items>(context, listen: false).updateItem(
        _editedItem.id,
        _editedItem,
      );
    } else {
      try {
        await Provider.of<Items>(context, listen: false).addItem(_editedItem);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text(error.toString()), //some thing went wrong
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => _editedItem = Item(
                        title: value,
                        id: _editedItem.id,
                        isFavorite: _editedItem.isFavorite,
                        price: _editedItem.price,
                        description: _editedItem.description,
                        imagePath: _pickedImage.path != null
                            ? _pickedImage.path
                            : _editedItem.imagePath,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onSaved: (value) => _editedItem = Item(
                        title: _editedItem.title,
                        id: _editedItem.id,
                        isFavorite: _editedItem.isFavorite,
                        price: double.parse(value),
                        description: _editedItem.description,
                        imagePath: _pickedImage.path != null
                            ? _pickedImage.path
                            : _editedItem.imagePath,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greter then zero';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      onSaved: (value) => _editedItem = Item(
                        title: _editedItem.title,
                        id: _editedItem.id,
                        isFavorite: _editedItem.isFavorite,
                        price: _editedItem.price,
                        description: value,
                        imagePath: _pickedImage.path != null
                            ? _pickedImage.path
                            : _editedItem.imagePath,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 charectersling';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      child: ImageInput(_selectImage),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

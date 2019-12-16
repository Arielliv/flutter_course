import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workshop1/providers/item.dart';
import 'package:workshop1/widgets/inputs/image_input.dart';

class ItemForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final initValues;
  final Item editedItem;
  final Function onUpdateField;
  final Function onSaveForm;

  ItemForm({
    @required this.formKey,
    @required this.initValues,
    @required this.editedItem,
    @required this.onUpdateField,
    @required this.onSaveForm,
  });

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _descriptionFocusNode = FocusNode();

  final _priceFocusNode = FocusNode();
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            initialValue: widget.initValues['title'],
            decoration: InputDecoration(labelText: 'Title'),
            textInputAction: TextInputAction.next,
            onSaved: (value) => widget.onUpdateField(
              Item(
                title: value,
                id: widget.editedItem.id,
                isFavorite: widget.editedItem.isFavorite,
                price: widget.editedItem.price,
                description: widget.editedItem.description,
                imagePath: _pickedImage.path != null
                    ? _pickedImage.path
                    : widget.editedItem.imagePath,
              ),
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
            initialValue: widget.initValues['price'],
            decoration: InputDecoration(labelText: 'Price'),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            focusNode: _priceFocusNode,
            onSaved: (value) => widget.onUpdateField(
              Item(
                title: widget.editedItem.title,
                id: widget.editedItem.id,
                isFavorite: widget.editedItem.isFavorite,
                price: double.parse(value),
                description: widget.editedItem.description,
                imagePath: _pickedImage.path != null
                    ? _pickedImage.path
                    : widget.editedItem.imagePath,
              ),
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
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_descriptionFocusNode),
          ),
          TextFormField(
            initialValue: widget.initValues['description'],
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
            onSaved: (value) => widget.onUpdateField(
              Item(
                title: widget.editedItem.title,
                id: widget.editedItem.id,
                isFavorite: widget.editedItem.isFavorite,
                price: widget.editedItem.price,
                description: value,
                imagePath: _pickedImage.path != null
                    ? _pickedImage.path
                    : widget.editedItem.imagePath,
              ),
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
    );
  }
}

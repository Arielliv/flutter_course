import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdeptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdeptiveFlatButton(this.text, this.handler);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text),
            onPressed: () => handler,
          )
        : FlatButton(
            child: Text(text),
            onPressed: () => handler,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
          );
  }
}

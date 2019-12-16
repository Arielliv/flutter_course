import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/screens/item_detail_screen.dart';
import '../providers/item.dart';
import '../providers/auth.dart';
import '../providers/items.dart';

class ItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Item>(context, listen: false);
    final items = Provider.of<Items>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ItemDetailScreen.routeName,
              arguments: item.id,
            );
          },
          child: Hero(
            tag: item.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/wix-logo.jpg'),
              image: FileImage(File(item.imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Item>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
            ),
          ),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.done),
            color: Theme.of(context).accentColor,
            onPressed: () {
              item.isFinished = !item.isFinished;
              items.updateItem(item.id, item);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Finished task!',
                  ),
                  action: SnackBarAction(
                    label: 'UNNDO',
                    onPressed: () {

                    },
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

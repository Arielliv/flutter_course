import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/screens/edit_item_screen.dart';
import 'package:workshop1/widgets/user_item_view.dart';

import '../widgets/app_drawer.dart';
import '../providers/items.dart';

class UserItemsScreen extends StatelessWidget {
  static const routeName = '/user-items';

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<Items>(context, listen: false).fetchAndSetItems(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Items'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshItems(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshItems(context),
                    child: Consumer<Items>(
                      builder: (context, itemsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: itemsData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UserItemView(
                                itemsData.items[i].id,
                                itemsData.items[i].title,
                                itemsData.items[i].imagePath,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
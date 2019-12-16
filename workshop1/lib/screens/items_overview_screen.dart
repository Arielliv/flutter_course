import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/widgets/app_drawer.dart';
import 'package:workshop1/widgets/items_grid.dart';

import '../providers/items.dart';

enum FilterOptions { Favorites, All, Finished, Unfinished }

class ItemsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ItemsOverviewScreen> {
  var _showMode = FilterOptions.All;
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isLoading = true;
      Provider.of<Items>(context).fetchAndSetItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fllater Workshop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showMode = FilterOptions.Favorites;
                } else if (selectedValue == FilterOptions.Finished) {
                  _showMode = FilterOptions.Finished;
                } else if (selectedValue == FilterOptions.Unfinished) {
                  _showMode = FilterOptions.Unfinished;
                } else {
                  _showMode = FilterOptions.All;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
              PopupMenuItem(
                  child: Text('Unfinished Tasks'),
                  value: FilterOptions.Unfinished),
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(
                  child: Text('Finished Tasks'), value: FilterOptions.Finished),
            ],
          ),
          // Consumer<Cart>(
          //   builder: (
          //     ctx,
          //     cartData,
          //     child,
          //   ) =>
          //       Badge(
          //     child: child,
          //     value: cartData.itemCount.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(Icons.shopping_cart),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routeName);
          //     },
          //   ),
          // )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ItemsGrid(_showMode),
    );
  }
}

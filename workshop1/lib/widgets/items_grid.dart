import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/screens/items_overview_screen.dart';
import 'package:workshop1/widgets/item_widget.dart';

import '../providers/items.dart';

class ItemsGrid extends StatelessWidget {
  final FilterOptions _showMode;

  ItemsGrid(this._showMode);

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Items>(context).itemsByShowMode(_showMode);
    
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: items.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: items[i],
        child: Container(
          child: ItemWidget(),
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

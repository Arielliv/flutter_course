import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final prodcuts = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: prodcuts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (ctx) => prodcuts[i],
        value: prodcuts[i],
        child: ProductItem(),
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

import 'package:flutter/material.dart';

import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get Products from the provider
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      //this approach is usually better to use in main.dart file
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
          create: (c) => products[i],

          ///or you can use shorter way (.value), and it works better with lists
          ///itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          ///value: products[i],)...
          child: ProductItem(
              //products[i].id, products[i].title, products[i].imageUrl
              )),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
    );
  }
}

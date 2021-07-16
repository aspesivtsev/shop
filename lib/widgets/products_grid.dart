import 'package:flutter/material.dart';
import '../models/product.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) => ProductItem(loadedProducts[i].id,
          loadedProducts[i].title, loadedProducts[i].imageUrl),
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
    );
  }
}

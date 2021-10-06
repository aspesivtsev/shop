import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///imprting only Cart class here to avoid coalisions of CartItem class
///which is present in both cart.dart and cart_item.dart.
import '../providers/cart.dart' show Cart;

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  //const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: (TextStyle(fontSize: 20)),
                ),

                ///it takes all available space in the row
                Spacer(),
                Chip(
                  ///.toStringAsFixed(2) gives 2 digits to show
                  label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                TextButton(onPressed: () {}, child: const Text('ORDER NOW')),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price),

            ///itemCount: cart.itemCount,
            itemCount: cart.items.length,
          ))
        ],
      ),
    );
  }
}

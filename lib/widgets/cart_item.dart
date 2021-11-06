import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  //const CartItem({Key? key}) : super(key: key);
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title});

  @override
  Widget build(BuildContext context) {
    ///виджет для удаления элемента свайпом в сторону
    return Dismissible(
      key: ValueKey(id),

      ///направление сдвига справа налево
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        //диалог с подтверждением yes/no
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                  onPressed: () {
                    ///передаем из модального окна значение true, что значит ничего не делать
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    ///передаем из модального окна значение true, что значит выполнить действие
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes')),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(8),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('\$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}

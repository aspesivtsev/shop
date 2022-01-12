import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //ChangeNotifierProvider gives content for rebuilding and updating only listeners
    // in previous versions you should use "builder" method instead of "create"
    //see products_grid.dart file for the example with .value
    ///create: (ctx) => Products()),
    ///с верхним вариантом если не работает и появляется ошибка "A Product was used after being disposed."
    ///тогда нужно использовать вариант с .value
    ///ChangeNotifierProvider.value(
    ///value: Products()),
    return MultiProvider(
        //MultiProvider дает возможность использовать несколько провайдеров в одном глобальном контексте
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Products(),
          ),
          //ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Orders(),
          )
          //ChangeNotifierProvider.value(value: Orders()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
                .copyWith(secondary: Colors.deepOrange),
          ),
          home: ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Shop'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;

  ///@override
  ///initState запускается один раз при старте виджета
  ///получаем тут список продуктов

  //void initState() {
  ///1 вариант
  ///Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  ///
  ///super.initState();}

  ///2 вариант это использовать didChangeDependencies вместо initState, как мы делали раньше
  ///но didChangeDependencies запускается не 1 раз, как initState, а много раз, поэтому нужно делать дополнительный помощник
  ///проводить проверку, чтобы инициализация прошла только 1 раз
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).fetchAndSetProducts();
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  /// 3 вариант использовать Future. мы используем его для того чтобы отложить его инициализацию
  /// т.е. фактически инициализация происходит мгновенно, но она пройдет как бы на втором круге,
  /// поэтому виджет уже будет проинициализирован и тогда все сработает
  /*
  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((_) => {Provider.of<Products>(context).fetchAndSetProducts()});
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });

              //print(selectedValue);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

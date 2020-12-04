import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/product_overview_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) => previousProduct
            ..getData(authValue.token, authValue.userId,
                previousProduct == null ? null : previousProduct.items),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (ctx, authValue, previousOrders) => previousOrders
            ..getData(authValue.token, authValue.userId,
                previousOrders == null ? null : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'lato',
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreens()
                        : AuthScreen();
                  },
                ),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop1/providers/auth.dart';
import 'package:workshop1/providers/items.dart';
import 'package:workshop1/screens/auth_screen.dart';
import 'package:workshop1/screens/edit_item_screen.dart';
import 'package:workshop1/screens/item_detail_screen.dart';
import 'package:workshop1/screens/items_overview_screen.dart';
import 'package:workshop1/screens/splash_screen.dart';
import 'package:workshop1/screens/user_items_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Items>(
          builder: (ctx, auth, prevpItems) => Items(
            auth.token,
            auth.userId,
            prevpItems == null ? [] : prevpItems.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Wix Flutter Workshop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.orange,
          ),
          home: auth.isAuth
              ? ItemsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ItemDetailScreen.routeName: (ctx) => ItemDetailScreen(),
            // CartScreen.routeName: (ctx) => CartScreen(),
            // OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserItemsScreen.routeName: (ctx) => UserItemsScreen(),
            EditItemScreen.routeName: (ctx) => EditItemScreen(),
          },
        ),
      ),
    );
  }
}

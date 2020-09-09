import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import 'package:restaurant_ui_kit/screens/splash.dart';
import 'package:restaurant_ui_kit/util/const.dart';

import './screens/refund_form.dart';
import './screens/qr_scanner_screen.dart';
import 'screens/offer_screen.dart';
import './providers/products.dart';
import './screens/add_product.dart';

import 'util/const.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => Products()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget child) {
        return MaterialApp(
            key: appProvider.key,
            debugShowCheckedModeBanner: false,
            navigatorKey: appProvider.navigatorKey,
            title: Constants.appName,
            theme: appProvider.theme,
            darkTheme: Constants.darkTheme,
            home: SplashScreen(),
            routes: {
              RefundForm.routeName: (ctx) => RefundForm(),
              QrCodeScanner.routeName: (ctx) => QrCodeScanner(),
              OfferScreen.routeName: (ctx) => OfferScreen(),
              AddProductScreen.routeName: (ctx) => AddProductScreen(),
            });
      },
    );
  }
}

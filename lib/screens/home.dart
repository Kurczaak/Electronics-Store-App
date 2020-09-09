import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/add_product.dart';
import 'package:restaurant_ui_kit/screens/dishes.dart';
import 'package:restaurant_ui_kit/screens/refund_form.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';
import 'package:restaurant_ui_kit/widgets/home_category.dart';
import 'package:restaurant_ui_kit/widgets/slider_item.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/app_provider.dart';
import '../widgets/home_tile.dart';
import './refund_form.dart';
import './offer_screen.dart';

import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/products.dart';

import '../widgets/overlay.dart' as ovrl;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  var overlayState;
  var overlayEntry;
  bool _initialized = false;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Future<void> showOverlay(BuildContext context) async {
    if (!_initialized) {
      setState(() {
        _initialized = true;
      });

      final provider = Provider.of<Products>(context, listen: true);
      await provider.fetchAndServeProducts();
      final products = provider.items;
      showDialog(
        context: context,
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ovrl.MyOverlay(products),
        barrierColor: Colors.black26,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    showOverlay(context);
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10.0),
                GridView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.25),
                  ),
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(OfferScreen.routeName),
                        child: HomeTile(
                            Icon(
                              Icons.shopping_basket,
                              color: Colors.white,
                            ),
                            "Nasza Oferta",
                            Colors.amber)),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(RefundForm.routeName),
                      child: HomeTile(
                          Icon(
                            Icons.subtitles,
                            color: Colors.white,
                          ),
                          "Wypełnij formularz",
                          Colors.blue),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AddProductScreen.routeName),
                      child: HomeTile(
                          Icon(
                            Icons.add_to_queue,
                            color: Colors.white,
                          ),
                          "Dodaj produkt",
                          Colors.indigo),
                    ),
                    HomeTile(
                        Icon(
                          Icons.phonelink_ring,
                          color: Colors.white,
                        ),
                        "Tekst 2",
                        Colors.blueGrey[400]),
                    HomeTile(
                        Icon(
                          Icons.settings_ethernet,
                          color: Colors.white,
                        ),
                        "Tekst 3",
                        Colors.purple),
                    HomeTile(
                        Icon(
                          Icons.not_listed_location,
                          color: Colors.white,
                        ),
                        "Tekst 4",
                        Colors.yellow),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/add_product.dart';

import '../widgets/home_tile.dart';
import './refund_form.dart';
import './offer_screen.dart';

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
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
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
                            Theme.of(context).accentColor)),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed(RefundForm.routeName),
                      child: HomeTile(
                          Icon(
                            Icons.subtitles,
                            color: Colors.white,
                          ),
                          "Wypełnij formularz",
                          Theme.of(context).accentColor),
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
                          Theme.of(context).accentColor),
                    ),
                    HomeTile(
                        Icon(
                          Icons.phonelink_ring,
                          color: Colors.white,
                        ),
                        "Tekst 2",
                        Theme.of(context).accentColor),
                    HomeTile(
                        Icon(
                          Icons.settings_ethernet,
                          color: Colors.white,
                        ),
                        "Tekst 3",
                        Theme.of(context).accentColor),
                    HomeTile(
                        Icon(
                          Icons.not_listed_location,
                          color: Colors.white,
                        ),
                        "Tekst 4",
                        Theme.of(context).accentColor),
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

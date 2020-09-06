import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_ui_kit/screens/dishes.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';
import 'package:restaurant_ui_kit/widgets/home_category.dart';
import 'package:restaurant_ui_kit/widgets/slider_item.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/app_provider.dart';

import '../widgets/overlay.dart' as ovrl;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  _showOverlay(BuildContext ctx) async {
    await Future.delayed(Duration(seconds: 1));
    var provider = Provider.of<AppProvider>(ctx, listen: false);
    var _initialized = provider.initialized;
    if (!_initialized) {
      var overlayState = Overlay.of(ctx);
      var overlayEntry = OverlayEntry(
        builder: (ctx) => ovrl.MyOverlay(),
        maintainState: false,
      );
      provider.setPromotions(overlayEntry);
      overlayState.insert(overlayEntry);
      provider.initialize();
    }
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    _showOverlay(context);
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
                    for (var j = 0; j < 6; j++)
                      Image.asset(
                        foods[j]['img'],
                        fit: BoxFit.cover,
                      ),
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

import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foods.dart';
import 'package:restaurant_ui_kit/widgets/grid_product.dart';

import 'package:provider/provider.dart';
import '../providers/models/product.dart';
import '../providers/products.dart';

class OfferScreen extends StatefulWidget {
  static const routeName = '/offer';

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen>
    with AutomaticKeepAliveClientMixin<OfferScreen> {
  bool _isLoading = true;

  void initState() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false)
          .fetchAndServeProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nasza Oferta'),
      ),
      body: RefreshIndicator(
        onRefresh: productsData.fetchAndServeProducts,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: products == null ? 0 : products.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ChangeNotifierProvider.value(
                              value: products[index], child: GridProduct()),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

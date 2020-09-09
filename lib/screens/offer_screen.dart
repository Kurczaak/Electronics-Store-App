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
  bool _isLoading = false;

  void initState() {
    //Provider.of<Products>(context).fetchAndSerProducts();
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration.zero).then((_) {
      // Sort of a workaround
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
                    Text(
                      "My Favorite Items",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: products == null ? 0 : products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GridProduct(products[index]);
                      },
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

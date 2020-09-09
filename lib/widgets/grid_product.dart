import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../providers/models/product.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class GridProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: true);
    final scaffold = Scaffold.of(context);
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "${product.imageUrl}",
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 3.0,
                child: CircleAvatar(
                  foregroundColor: Colors.yellow,
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 25,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: FittedBox(
                      child: Text(
                        '${product.price.toStringAsFixed(2)} zł',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: () async {
                    try {
                      await product.toggleFavorite();
                    } catch (error) {
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(SnackBar(
                        content: Text('Could not add to favorites!'),
                      ));
                    }
                  },
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: max(MediaQuery.of(context).size.height / 30, 25),
              child: FittedBox(
                child: Text(
                  "${product.title}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Row(
              children: [
                SmoothStarRating(
                  starCount: 5,
                  color: Constants.ratingBG,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  borderColor: Constants.ratingBG,
                  allowHalfRating: true,
                  rating: product.rate,
                  size: 10.0,
                ),
                Text(" ${product.rate} (${253} Reviews)",
                    style: TextStyle(
                      fontSize: 11.0,
                    )),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(product);
            },
          ),
        );
      },
    );
  }
}

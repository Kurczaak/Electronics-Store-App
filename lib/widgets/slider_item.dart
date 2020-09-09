import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:restaurant_ui_kit/util/const.dart';
import 'package:restaurant_ui_kit/widgets/smooth_star_rating.dart';
import '../providers/models/product.dart';

class SliderItem extends StatefulWidget {
  final Product product;

  SliderItem(this.product);

  @override
  _SliderItemState createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
  bool _isFavorite;
  @override
  Widget build(BuildContext context) {
    _isFavorite = widget.product.isFavorite;
    return InkWell(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  "${widget.product.imageUrl}",
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
              Positioned(
                right: -10.0,
                bottom: 3.0,
                child: RawMaterialButton(
                  onPressed: () async {
                    setState(() {});
                    try {
                      await widget.product.toggleFavorite();
                    } catch (error) {
                      print(error);
                    }
                  },
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Icon(
                      widget.product.isFavorite
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
            padding: EdgeInsets.all(10),
            child: Text(
              "${widget.product.title}",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                SmoothStarRating(
                  starCount: 5,
                  color: Constants.ratingBG,
                  allowHalfRating: true,
                  rating: widget.product.rate,
                  size: 10.0,
                ),
                Text(
                  " ${widget.product.rate} (${233} Reviews)",
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(widget.product);
            },
          ),
        );
      },
    );
  }
}

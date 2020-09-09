import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant_ui_kit/widgets/slider_item.dart';
import '../screens/offer_screen.dart';

class MyOverlay extends StatelessWidget {
  final promotions;
  MyOverlay(this.promotions);

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) {
        Navigator.of(context).pop();
      },
      direction: DismissDirection.up,
      key: UniqueKey(),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.orange,
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Nasze promocje',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                promotions.isEmpty
                    ? CircularProgressIndicator()
                    : CarouselSlider(
                        autoPlayInterval: Duration(seconds: 5),
                        height: MediaQuery.of(context).size.height * 0.45,
                        items: [
                          ...promotions.map((product) {
                            return SliderItem(product);
                          }).toList(),
                        ],
                        autoPlay: true,
                        viewportFraction: 1.0,
                      ),
                Align(
                  child: RaisedButton(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('Sprawdź inne produkty'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(OfferScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

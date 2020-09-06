import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/providers/app_provider.dart';
import '../util/foods.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant_ui_kit/widgets/slider_item.dart';

import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class MyOverlay extends StatelessWidget {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var vertPadding = MediaQuery.of(context).padding.vertical;
    return Dismissible(
      onDismissed: (_) {
        Provider.of<AppProvider>(context, listen: false).promotions.remove();
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
                            Provider.of<AppProvider>(context, listen: false)
                                .promotions
                                .remove();
                          },
                          //color: Theme.of(context).errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
                CarouselSlider(
                  autoPlayInterval: Duration(seconds: 5),
                  height: MediaQuery.of(context).size.height * 0.45,
                  items: map<Widget>(
                    foods,
                    (index, i) {
                      Map food = foods[index];
                      return SliderItem(
                        img: food['img'],
                        isFav: false,
                        name: food['name'],
                        rating: 5.0,
                        raters: 23,
                      );
                    },
                  ).toList(),
                  autoPlay: true,
                  //enlargeCenterPage: true,
                  viewportFraction: 1.0,
//              aspectRatio: 2.0,
                  onPageChanged: (index) {
                    //TODO
                  },
                ),
                Align(
                  child: RaisedButton(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text('Przejdź do oferty'),
                    onPressed: () {
                      Navigator.of(context).pop();
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

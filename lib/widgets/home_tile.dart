import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foods.dart';

class HomeTile extends StatelessWidget {
  final Widget picture;
  final String text;
  final Color color;

  HomeTile(this.picture, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: GridTile(
        child: FittedBox(
          fit: BoxFit.contain,
          child: picture,
        ),
        footer: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 30,
          alignment: Alignment.bottomRight,
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ),
      ),
    );
  }
}

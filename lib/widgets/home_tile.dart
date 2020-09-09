import 'dart:ui';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final Widget picture;
  final String text;
  final Color color;

  HomeTile(this.picture, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: color,
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: picture,
            ),
          ),
          footer: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 30,
            alignment: Alignment.bottomCenter,
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
      ),
    );
  }
}

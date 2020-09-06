import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/util/foods.dart';

class HomeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          foods[1]['img'],
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

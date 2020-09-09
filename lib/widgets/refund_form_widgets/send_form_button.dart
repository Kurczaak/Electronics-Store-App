import 'package:flutter/material.dart';

class SendFormButton extends StatelessWidget {
  final onPressed;
  final color;
  SendFormButton({this.onPressed, this.color = Colors.red});
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.email),
      label: Text('Wyślij formularz'),
      onPressed: onPressed,
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: color,
      padding: EdgeInsets.symmetric(vertical: 15),
    );
  }
}

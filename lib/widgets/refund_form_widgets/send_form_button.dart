import 'package:flutter/material.dart';

class SendFormButton extends StatefulWidget {
  final onPressed;
  final color;
  SendFormButton({this.onPressed, this.color = Colors.red});

  @override
  _SendFormButtonState createState() => _SendFormButtonState();
}

class _SendFormButtonState extends State<SendFormButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.email),
      label: Text('Wyślij formularz'),
      onPressed: widget.onPressed,
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: widget.color,
      padding: EdgeInsets.symmetric(vertical: 15),
    );
  }
}

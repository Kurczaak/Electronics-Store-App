import 'package:flutter/material.dart';
import 'package:restaurant_ui_kit/screens/qr_scanner_screen.dart';

class QrScanner extends StatelessWidget {
  final passQrCode;
  QrScanner(this.passQrCode);

  Future<void> openScanner(BuildContext context) async {
    final result =
        await Navigator.of(context).pushNamed(QrCodeScanner.routeName);
    passQrCode(result);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
              icon: Container(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    "assets/qr.png",
                  )),
              label: Text('Zeskanuj kod QR'),
              textColor: Theme.of(context).cursorColor,
              onPressed: () {
                openScanner(context);
              }),
        ),
      ],
    );
  }
}

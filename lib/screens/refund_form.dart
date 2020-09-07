import 'package:flutter/material.dart';
import '../widgets/qr_scanner_item.dart';
import '../widgets/image_input.dart';

class RefundForm extends StatefulWidget {
  static const routeName = '/form';

  @override
  _RefundFormState createState() => _RefundFormState();
}

class _RefundFormState extends State<RefundForm> {
  final titleController = TextEditingController();
  String qrCode;
  void getQrCode(String code) {
    qrCode = code;
    titleController.text = code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wypełnij formularz zwrotu'),
        actions: [
          Switch(
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Nazwa Produktu'),
                      controller: titleController,
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(labelText: 'Opis'),
                      maxLength: 600,
                      maxLines: 5,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(),
                    QrScanner(getQrCode),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.email),
            label: Text('Wyślij formularz'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Czy na pewno chcesz wysłać formularz?'),
                  content: Text(
                      'Wysłanie formularza przeniesie Cię do ekranu głównego'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Tak'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Nie'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ),
              );
            },
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
        ],
      ),
    );
  }
}

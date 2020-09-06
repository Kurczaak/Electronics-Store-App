import 'package:flutter/material.dart';
import '../widgets/image_input.dart';

class RefundForm extends StatefulWidget {
  static const routeName = '/form';

  @override
  _RefundFormState createState() => _RefundFormState();
}

class _RefundFormState extends State<RefundForm> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wypełnij formularz zwrotu'),
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
                      controller: _titleController,
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(labelText: 'Opis'),
                      maxLines: 5,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

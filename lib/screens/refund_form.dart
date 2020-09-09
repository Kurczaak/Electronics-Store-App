import 'package:flutter/material.dart';
import '../widgets/refund_form_widgets/qr_scanner_item.dart';
import '../widgets/refund_form_widgets/image_input.dart';
import '../widgets//refund_form_widgets/send_form_button.dart';

class RefundForm extends StatefulWidget {
  static const routeName = '/form';

  @override
  _RefundFormState createState() => _RefundFormState();
}

class _RefundFormState extends State<RefundForm> {
  var validForm = false;
  final _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final titleController = TextEditingController();
  var qrCode = '';
  var numImg = 0;
  bool warning = false;

  void getQrCode(String code) {
    setState(() {
      qrCode = code;
      titleController.text = code;
      validate();
    });
  }

  void getNumImg(int numberOfImages) {
    setState(() {
      numImg = numberOfImages;
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_form.currentState.validate()) _form.currentState.save();
  }

  bool validate() {
    setState(() {
      if (_form.currentState.validate() && numImg > 0)
        validForm = true;
      else
        validForm = false;
    });
    return validForm;
  }

  void onSendButtonPressed(bool validated) {
    if (validated) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Czy na pewno chcesz wysłać formularz?'),
          content:
              Text('Wysłanie formularza przeniesie Cię do ekranu głównego'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tak'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _saveForm();
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
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Uzupełnij formularz!'),
          content: Text(
              'Upewnij się, że pola Nazwa Produktu oraz Opis nie są puste oraz dodałeś przynajmniej jedno zdjęcie'),
          actions: <Widget>[
            FlatButton(
              child: Text('Rozumiem'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _descriptionFocusNode.unfocus();
        _titleFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wypełnij formularz zwrotu'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Form(
                key: _form,
                onWillPop: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Powrót'),
                    content: Text(
                        'Czy na pewno chcesz powrócić do menu gównego? Wprowadzone dane zostaną utracone'),
                    actions: [
                      FlatButton(
                        child: Text('Tak'),
                        onPressed: () {
                          _saveForm();

                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Nie'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        QrScanner(getQrCode),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Produkt uszkodzony',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: warning
                                      ? Colors.red
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color),
                            ),
                            Switch(
                              value: warning,
                              onChanged: (myVal) {
                                setState(() {
                                  warning = myVal;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Nazwa Produktu'),
                          onChanged: (_) => validate(),
                          focusNode: _titleFocusNode,
                          controller: titleController,
                          textInputAction: TextInputAction.next,
                          //keyboardType: TextInputType.text,
                          // Rhe "SPAN_EXCLUSIVE_EXCLUSIVE" error workaround
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          //----------------------
                          textCapitalization: TextCapitalization.sentences,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                          validator: (value) {
                            if (value.isEmpty) return 'Podaj nazwę produktu';
                            return null;
                          },
                        ),
                        Divider(),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Opis'),
                          onChanged: (_) => validate(),
                          focusNode: _descriptionFocusNode,
                          maxLength: 600,
                          maxLines: 7,
                          minLines: 1,
                          // keyboardType: TextInputType.multiline,
                          // Rhe "SPAN_EXCLUSIVE_EXCLUSIVE" error workaround
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          //----------------------
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.isEmpty) return 'Dodaj opis reklamacji';
                            return null;
                          },
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        ImageInput(getNumImg, validate),
                        Divider(),
                        SendFormButton(
                          onPressed: () => onSendButtonPressed(validForm),
                          color: validForm
                              ? Theme.of(context).accentColor
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

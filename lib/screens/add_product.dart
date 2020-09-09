import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../providers/models/product.dart';
import '../providers/products.dart';
import 'package:restaurant_ui_kit/util/const.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final List<String> _categoriesList = Product.listOfCategories;
  var _isLoading = false;

  var _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
      category: Category.TV,
      rate: 0,
      isFavorite: false);
  Map<String, String> _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'price': '0.00',
    'imageUrl':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png',
    'rate': '3',
    'category': 'Brak',
  };

  var _initialized = false;

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // If editing is needed
  // @override
  // void didChangeDependencies() {
  //   if (!_initialized) {
  //     final productId = ModalRoute.of(context).settings.arguments;
  //     if (productId != null) {
  //       _editedProduct = Provider.of<Products>(context).findById(productId);
  //       _initValues = {
  //         'title': _editedProduct.title,
  //         'price': _editedProduct.price.toString(),
  //         'id': _editedProduct.id,
  //         'description': _editedProduct.description,
  //         'url': _editedProduct.imageUrl,
  //       };
  //     }
  //     _imageUrlController.text = _editedProduct.imageUrl;
  //   }
  //   _initialized = true;
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _priceFocusNode.unfocus();
        _imageUrlFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dodaj produkt'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveForm,
            )
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      // Tytuł
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Nazwa produktu',
                        ),
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Proszę podaj nazwę produktu';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct =
                              Product.newTitle(_editedProduct, value);
                        },
                      ),
                      // Cena
                      TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(
                            labelText: 'Cena',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Proszę podaj cenę';
                            else if (!value
                                .contains(new RegExp(r'^\d{0,8}(\.\d{1,4})?$')))
                              return 'Podaj poprawną cenę';
                            else if (double.parse(value) < 0)
                              return 'Wprowadź liczbę nieujemną';
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          onSaved: (value) {
                            _editedProduct = Product.newPrice(
                                _editedProduct, double.parse(value));
                          }),
                      // Opis
                      TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Opis produktu',
                          ),
                          validator: (value) {
                            if (value.isEmpty) return 'Prosze podać opis';
                            return null;
                          },
                          minLines: 1,
                          maxLines: 3,
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          onSaved: (value) {
                            _editedProduct =
                                Product.newDescription(_editedProduct, value);
                          }),
                      // Kategorie
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: DropdownButton<String>(
                          value: _initValues['category'],
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String newValue) {
                            _editedProduct = Product.newCategory(_editedProduct,
                                Product.stringToCategory(newValue));
                            setState(() {
                              _initValues['category'] = newValue;
                            });
                          },
                          items: _categoriesList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: (value),
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // Ilość gwiazdek
                      Center(
                        child: SmoothStarRating(
                          color: Constants.ratingBG,
                          borderColor: Constants.ratingBG,
                          rating: 3,
                          isReadOnly: false,
                          size: 50,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                          onRated: (value) {
                            _editedProduct =
                                Product.newRate(_editedProduct, value);
                          },
                        ),
                      ),
                      // Obrazek
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                    'Podaj URL zdjęcia',
                                    textAlign: TextAlign.center,
                                  ))
                                : FittedBox(
                                    child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Podaj adres URL zdjęcia';
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Adres URL zdjęcia'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) => _saveForm(),
                                onChanged: (value) {
                                  setState(() {
                                    _editedProduct = Product.newImageUrl(
                                        _editedProduct, value);
                                  });
                                },
                                onSaved: (value) {
                                  _editedProduct = Product.newImageUrl(
                                      _editedProduct, value);
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

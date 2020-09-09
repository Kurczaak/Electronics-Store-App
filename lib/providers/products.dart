import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './models/http_exception.dart';
import './models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Tv',
    //   description: 'This is a dummy tv',
    //   price: 1499.99,
    //   imageUrl:
    //       'https://www.mediaexpert.pl/media/cache/gallery/product/4/165/460/73/wrlazb74/images/19/1941067/Telewizor-PHILIPS-LED-58PUS7304-bok-lewy__1.jpg',
    //   rate: 1,
    //   category: Category.TV,
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Washing Machinge',
    //   description: 'This is a dummy Washing Machinge',
    //   price: 2499.99,
    //   imageUrl:
    //       'https://www.mediaexpert.pl/media/cache/gallery/product/2/557/679/115/iervzono/images/13/1386053/Pralka-BOSCH-WAN242MSPL-front.jpg',
    //   rate: 5,
    //   category: Category.AGD,
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Laptop',
    //   description: 'This is a dummy laptop',
    //   price: 1229.99,
    //   imageUrl:
    //       'https://www.mediaexpert.pl/media/cache/gallery/product/2/235/645/541/9xgbwdbd/images/24/2409742/Laptop-ACER-Nitro-5-front-prawy.jpg',
    //   rate: 4,
    //   category: Category.Computers,
    // ),
    // Product(
    //   id: 'p1',
    //   title: 'Smartphone',
    //   description: 'This is a dummy smartphone',
    //   price: 829.99,
    //   imageUrl:
    //       'https://www.mediaexpert.pl/media/cache/gallery/product/2/297/985/274/wakcffxl/images/24/2435102/Smartfon-SAMSUNG-Galaxy-SM-A315-A31-Czarny-Front-Plecki__1.jpg',
    //   rate: 2,
    //   category: Category.Smartphones,
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://ecommerce-app-project.firebaseio.com/products.json';

    try {
      final response = await http.post(
        url,
        body: product.toJsonFormat(),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;

      final id = data['name'];
      final newProduct = Product.newId(product, id);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://ecommerce-app-project.firebaseio.com/$id.json';
    final prodIndx = _items.indexWhere((element) => element.id == id);

    await http.patch(
      url,
      body: newProduct.toJsonFormat(),
    );

    if (prodIndx >= 0) {
      _items[prodIndx] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://ecommerce-app-project.firebaseio.com/$id.json';
    // index and product caching
    final productToDeleteIndex =
        _items.indexWhere((element) => element.id == id);
    var productToDelete = _items[productToDeleteIndex];

    // remove product locally
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    // send a delete request
    final response = await http.delete(url);
    // error
    if (response.statusCode >= 400) {
      _items.insert(
          productToDeleteIndex, productToDelete); // bring the item back
      notifyListeners();
      throw HttpException('Deleting failed:' + response.statusCode.toString());
    }

    productToDelete = null;
  }

  Future<void> fetchAndServeProducts() async {
    const url = 'https://ecommerce-app-project.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return;
      final List<Product> loadedProducts = [];
      data.forEach(
        (key, value) {
          final temp = Product.fromMap(value);
          final newProd = Product.newId(temp, key);
          loadedProducts.add(newProd);
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}

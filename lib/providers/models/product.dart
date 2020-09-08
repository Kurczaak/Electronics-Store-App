import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

enum Category { TV, AGD, Computers, Smartphones, RTV }

class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  int rate;
  Category category;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.rate,
    @required this.category,
    this.isFavorite = false,
  });

  Product.fromProduct(Product another) {
    this.id = another.id;
    this.title = another.title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.imageUrl = map['imageUrl'];
    this.rate = map['rate'];
    this.category = map['category'];
    this.isFavorite = map['isFavorite'];
  }

  String toJsonFormat() {
    final Map<String, dynamic> mappedProduct = {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'rate': this.rate,
      'category': this.category,
      'isFavorite': this.isFavorite,
    };
    return json.encode(mappedProduct);
  }
}

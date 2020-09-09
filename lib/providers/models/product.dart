import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

enum Category { TV, AGD, Computers, Smartphones, RTV, undefinded }

class Product {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  double rate;
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
    this.category = Product.stringToCategory(map['category']);
    this.isFavorite = map['isFavorite'];
  }

  Product.newId(Product another, String id) {
    this.id = id;
    this.title = another.title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newTitle(Product another, String title) {
    this.id = another.id;
    this.title = title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newDescription(Product another, String description) {
    this.id = another.id;
    this.title = another.title;
    this.description = description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newPrice(Product another, double price) {
    this.id = another.id;
    this.title = another.title;
    this.description = another.description;
    this.price = price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newImageUrl(Product another, String imageUrl) {
    this.id = another.id;
    this.title = another.title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = imageUrl;
    this.rate = another.rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newRate(Product another, double rate) {
    this.id = another.id;
    this.title = another.title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = rate;
    this.category = another.category;
    this.isFavorite = another.isFavorite;
  }

  Product.newCategory(Product another, Category category) {
    this.id = another.id;
    this.title = another.title;
    this.description = another.description;
    this.price = another.price;
    this.imageUrl = another.imageUrl;
    this.rate = another.rate;
    this.category = category;
    this.isFavorite = another.isFavorite;
  }

  String toJsonFormat() {
    final Map<String, dynamic> mappedProduct = {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'rate': this.rate,
      'category': Product.categoryToString(this.category),
      'isFavorite': this.isFavorite,
    };
    return json.encode(mappedProduct);
  }

  static String categoryToString(Category category) {
    switch (category) {
      case Category.AGD:
        return 'AGD';
      case Category.Computers:
        return 'Komputery';
      case Category.RTV:
        return 'RTV';
      case Category.Smartphones:
        return 'Smartfony';
      case Category.TV:
        return 'TV';
      default:
        return 'Brak';
    }
  }

  static Category stringToCategory(String category) {
    switch (category) {
      case 'AGD':
        return Category.AGD;
      case 'Komputery':
        return Category.Computers;
      case 'RTV':
        return Category.RTV;
      case 'Smartfony':
        return Category.Smartphones;
      case 'TV':
        return Category.TV;
      default:
        return Category.undefinded;
    }
  }

  static List<String> get listOfCategories {
    return (Category.values.map((category) {
      return Product.categoryToString(category);
    }).toList());
  }
}

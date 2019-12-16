import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Item with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imagePath;
  bool isFavorite;
  bool isFinished;

  final String baseUrl = 'https://flutter-workshop-eef86.firebaseio.com';

  Item({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    this.imagePath,
    this.isFavorite = false,
    this.isFinished = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = '$baseUrl/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
      throw error;
    }
  }
}

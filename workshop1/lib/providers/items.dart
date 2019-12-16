import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:workshop1/providers/item.dart';
import 'package:workshop1/screens/items_overview_screen.dart';
import '../models/http_exception.dart';

class Items with ChangeNotifier {
  final String baseUrl = 'https://flutter-workshop-eef86.firebaseio.com';
  List<Item> _items = [];

  final String authToken;
  final String userId;

  Items(this.authToken, this.userId, this._items);

  List<Item> get items {
    return [..._items];
  }

  List<Item> get favoritesItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  List<Item> get finishedItems {
    return _items.where((item) => item.isFinished).toList();
  }

  List<Item> get unfinishedItems {
    return _items.where((item) => !item.isFinished).toList();
  }

  List<Item> itemsByShowMode(FilterOptions showMode) {
    if (showMode == FilterOptions.Favorites) {
      return this.favoritesItems;
    } else if (showMode == FilterOptions.Finished) {
      return this.finishedItems;
    } else if (showMode == FilterOptions.Unfinished) {
      return this.unfinishedItems;
    } else {
      return this.items;
    }
  }

  Item findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchAndSetItems([bool filterByUser = false]) async {
    final filterUrl =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = '$baseUrl/items.json?auth=$authToken&$filterUrl';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      } else {
        final url = '$baseUrl/userFavorites/$userId.json?auth=$authToken';
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
        final List<Item> loadedItems = [];
        extractedData.forEach((itemId, itemData) {
          loadedItems.add(Item(
            id: itemId,
            title: itemData['title'],
            description: itemData['description'],
            price: itemData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[itemId] ?? false,
            imagePath: itemData['imagePath'],
            isFinished: itemData['isFinished'],
          ));
        });
        _items = loadedItems;

        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Item item) async {
    final url = '$baseUrl/items.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'price': item.price,
            'imagePath': item.imagePath,
            'creatorId': userId,
            'isFinished': item.isFinished,
          }));

      final newItem = Item(
        title: item.title,
        description: item.description,
        price: item.price,
        imagePath: item.imagePath,
        id: json.decode(response.body)['name'],
      );

      _items.add(newItem);
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateItem(String id, Item newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      final url = '$baseUrl/items/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newItem.title,
              'description': newItem.description,
              'price': newItem.price,
              'imagePath': newItem.imagePath,
              'isFinished': newItem.isFinished,
            }));
        _items[itemIndex] = newItem;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('got a problem');
    }
  }

  Future<void> deleteItem(String id) async {
    final url = '$baseUrl/items/$id.json?auth=$authToken';
    final existingItemIndex = _items.indexWhere((item) => item.id == id);
    var existingItem = _items[existingItemIndex];

    _items.removeAt(existingItemIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could not delete item');
    } else {
      existingItem = null;
    }
  }
}

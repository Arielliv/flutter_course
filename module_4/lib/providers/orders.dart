import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/orderItem.dart';
import '../models/cartItem.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://flutter-course-9a6bf.firebaseio.com/orders.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) {
        return;
      } else {
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item["id"],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item["title"]))
                .toList(),
          ));
        });
        _orders = loadedOrders.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://flutter-course-9a6bf.firebaseio.com/orders.json?auth=$authToken';
    final timeStemp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "dateTime": timeStemp.toIso8601String(),
            "products": cartProducts
                .map((product) => {
                      'id': product.id,
                      'title': product.title,
                      'quantity': product.quantity,
                      'price': product.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStemp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

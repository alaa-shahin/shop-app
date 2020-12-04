import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrdersItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrdersItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrdersItem> _orders = [];
  String authToken;
  String userId;

  getData(String token, String uid, List<OrdersItem> orders) {
    authToken = token;
    userId = uid;
    _orders = orders;
    notifyListeners();
  }

  List<OrdersItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-cda40.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final List<OrdersItem> loadedOrders = [];
      extractData.forEach((key, value) {
        loadedOrders.add(
          OrdersItem(
            id: key,
            amount: value['amount'],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shopapp-cda40.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProduct
                .map(
                  (e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  },
                )
                .toList(),
          }));
      _orders.insert(
        0,
        OrdersItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

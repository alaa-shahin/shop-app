import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrdersItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('\$${order.amount}'),
        subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
        children: order.products
            .map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      e.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${e.quantity} x \$${e.price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

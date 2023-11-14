import 'package:flutter/material.dart';
import 'package:du_an_fashion/consts.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ Hàng'),
        leading: Icon(Icons.shopping_cart),
        backgroundColor: g2,
      ),
    );
  }
}

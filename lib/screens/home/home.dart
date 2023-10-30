import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigator.of(context).pushReplacementNamed();
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
           _signOut(context);
          },
          child: Text('Đăng xuất'),
        ),
      ),
    );
  }
}

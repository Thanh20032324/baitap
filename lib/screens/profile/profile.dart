import 'package:flutter/material.dart';
import 'package:du_an_fashion/consts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Cá Nhân'),
        leading: Icon(Icons.person_sharp),
        backgroundColor: g2,
      ),
    );
  }
}

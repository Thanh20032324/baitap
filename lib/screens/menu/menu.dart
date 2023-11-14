import 'package:du_an_fashion/screens/cart/cart.dart';
import 'package:du_an_fashion/screens/home/home.dart';
import 'package:du_an_fashion/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);


  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _currentIndex = 0;
  bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    checkAdmin(); // Kiểm tra quyền admin khi màn hình Menu được khởi tạo
  }
  void checkAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      String email = user.email ?? "";
      List<String> adminUser = ['thanh2003@gmail.com'];
      if(adminUser.contains(email)){
        setState(() {
          _isAdmin = true;
        });
      }else{
        setState(() {
          _isAdmin = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    final List<Widget> _screen = [
      Home(isAdmin: _isAdmin),
      Cart(),
      Profile(),
    ];
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}


import 'package:du_an_fashion/screens/login/resigter.dart';
import 'package:du_an_fashion/screens/menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:du_an_fashion/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage  extends StatefulWidget {
  const LoginPage ({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _showSnackBar(BuildContext context , String message){
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
         content: Text(message)
     ),
    );
  }
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  List<String> adminUser = ['thanh2003@gmail.com'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // lấy kích thước thiết bị

    Future<void> loginUser(String email, String password) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email,
            password: password
        );
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Menu()
              ),
          );
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'user-not-found') {
         _showSnackBar(context, 'Email không tồn tại');
        } else if (e.code == 'wrong-password') {
          _showSnackBar(context, 'Mật khẩu không đúng');
        }
      }catch(e){
        print(e);
      }
    }


    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [g1, g2],
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.030),
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.center,
              overflowSpacing: size.height * 0.014,
              children: [
                Image.asset(image1),

                SizedBox(height: size.height * 0.024),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: kInputColor),
                  onChanged: (value) {
                    email.text = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "Email",
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(uerIcon),
                    ),
                    fillColor: kWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: kInputColor),
                  onChanged: (value) {
                    password.text = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 25.0),
                    filled: true,
                    hintText: "Password",
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(keyIcon),
                    ),
                    fillColor: kWhiteColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.080,
                    decoration: BoxDecoration(
                      color: kButtonColor,
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    loginUser(email.text, password.text);
                  },
                ),
                SizedBox(height: size.height * 0.014),
                SvgPicture.asset("assets/icons/design.svg"),
                SizedBox(height: size.height * 0.014),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: size.height * 0.080,
                    decoration:  BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 45,
                          spreadRadius: 0,
                          color: Color.fromRGBO(120, 37, 139, 0.25),
                          offset: Offset(0, 25),
                        )
                      ],
                      borderRadius: BorderRadius.circular(37),
                      color: const Color.fromRGBO(225, 225, 225, 0.28),
                    ),
                    child: const Text(
                      "Create an Account",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Resigter())
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

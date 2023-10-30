import 'package:du_an_fashion/screens/home/home.dart';
import 'package:du_an_fashion/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:du_an_fashion/consts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Resigter extends StatefulWidget {

  const Resigter({super.key});

  @override

  State<Resigter> createState() => _ResigterState();
}

class _ResigterState extends State<Resigter> {
  void _showSnackBar(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
          content: Text(message)
      ),
    );
  }
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    Future<void> registerUser(String email, String password) async{
      try {

        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home())
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _showSnackBar(context, 'Mật khẩu yêu vui lòng nhập lại');
        } else if (e.code == 'email-already-in-use') {
          _showSnackBar(context, 'Email đã tồn tại');
        }
      } catch (e) {
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
                  controller: email,
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
                  controller: password,
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
                      onPressed: () {
                      },
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
                      "Register",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    registerUser(email.text, password.text);

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
                      "Login",
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder:  (context) => LoginPage())
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

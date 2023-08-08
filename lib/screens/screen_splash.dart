import 'dart:async';

import 'package:english_vocabulary_book/main.dart';
import 'package:english_vocabulary_book/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), (){
      moveScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Icon(Icons.collections_bookmark, color: Colors.deepPurpleAccent, size: 50,),
      ),
    );
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    return isLogin;
  }
  
  void moveScreen() async {
    await checkLogin().then((isLogin){
      if(isLogin){
        Get.offAll(WordsList());
      } else {
        Get.offAll(LoginScreen());
      }
    });
  }

}

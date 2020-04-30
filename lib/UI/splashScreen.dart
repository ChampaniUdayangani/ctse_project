//Coded by S.M.M.K. Subasinghe, IT17134736

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:ctse_project/UI/homePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadApp();
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/splash_screen.png'),
          fit: BoxFit.cover
        ),
      ),
    );
  }

  Future<Timer> loadApp() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
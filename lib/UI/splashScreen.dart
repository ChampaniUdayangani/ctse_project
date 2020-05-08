//Coded by S.M.M.K. Subasinghe, IT17134736
//Coded with references from https://fluttermaster.com/create-splash-screen-in-flutter/

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

  //Build the splash screen using the provided asset
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/splash_screen_2.png'),
          fit: BoxFit.cover
        ),
      ),
    );
  }

  //Set timer for the splash screen
  Future<Timer> loadApp() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  //Set navigation for the next page once the splash screen is finished loading
  onDoneLoading() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
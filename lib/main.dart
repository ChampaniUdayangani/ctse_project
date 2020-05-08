// main.dart
import 'package:flutter/material.dart';


//call the stateless widget
import 'package:ctse_project/UI/splashScreen.dart';

void main() => runApp(MyApp());

//create the main view with Hotel List page
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.indigo
        ),
        home: SplashScreen()
    );
  }
}

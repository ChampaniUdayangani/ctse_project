import 'package:flutter/material.dart';

import 'package:ctse_project/UI/splashScreen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.indigo
        ),
        home: SplashScreen()
    );
  }
}

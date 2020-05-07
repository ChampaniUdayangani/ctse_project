/*
IT16023574
Udayangani Hamy W.C.
*/

// main.dart
import 'package:flutter/material.dart';
import 'package:ctse_project/UI/hotelList.dart';

//call the stateless widget
void main() => runApp(MyApp());

//create the main view with Hotel List page
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.indigo
        ),
        home: HotelListPage()
    );
  }
}

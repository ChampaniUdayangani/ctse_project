import 'package:flutter/material.dart';
import 'package:ctse_project/UI/hotelList.dart';
import 'package:ctse_project/UI/hotelDetails.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.yellowAccent
        ),
        home: HotelListPage()
    );
  }
}

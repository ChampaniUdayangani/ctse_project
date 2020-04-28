import 'package:flutter/material.dart';

class HotelReviewPage extends StatefulWidget {
  @override
  HotelReviewState createState() => HotelReviewState();
}

class HotelReviewState extends State<HotelReviewPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
          primaryColor: Colors.indigo
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hotel reviews'),
        ),
      ),
    );
  }
}
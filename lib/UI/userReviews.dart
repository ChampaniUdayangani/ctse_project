import 'package:flutter/material.dart';

class UserReviewPage extends StatefulWidget {
  @override
  UserReviewState createState() => UserReviewState();
}

class UserReviewState extends State<UserReviewPage> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
          primaryColor: Colors.indigo
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Your reviews'),
          ),
      ),
    );
  }
}
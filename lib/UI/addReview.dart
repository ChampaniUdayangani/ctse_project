//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewPage extends StatefulWidget {
  DocumentSnapshot _receivedDocument;

  //Overloaded constructor for widget
  AddReviewPage(DocumentSnapshot document) {
    this._receivedDocument = document;
  }

  @override
  AddReviewState createState() => AddReviewState(this._receivedDocument);
}

class AddReviewState extends State<AddReviewPage> {
  final String _username = "Kasun Seneviratne";
  String _hotelname;

  final _reviewFormKey = GlobalKey<FormState>();
  String review;
  int stars;
  Timestamp timestamp = Timestamp.now();

  //Overloaded constructor for state
  AddReviewState(DocumentSnapshot document) {
    this._hotelname = document["name"];
  }

  Widget buildBody(BuildContext context) {
    var rating = 0.0;

    return Container(
      child: RatingBar(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          print(rating);
        },
      )
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Write a review"),
        ),
        body: buildBody(context)
      )
    );
  }
}
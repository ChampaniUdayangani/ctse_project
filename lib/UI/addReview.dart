//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Container();
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
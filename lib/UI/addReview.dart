//Coded by S.M.M.K. Subasinghe, IT17134736
//Coded with references from https://pub.dev/packages/flutter_rating_bar
//Coded with references from https://api.flutter.dev/flutter/widgets/Form-class.html

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/API/reviewAPI.dart';
import 'package:ctse_project/UI/hotelList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ctse_project/model/review.dart';

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
  String _review;
  int _rating = 1;
  Timestamp _timestamp = Timestamp.now();

  //Overloaded constructor for state
  AddReviewState(DocumentSnapshot document) {
    this._hotelname = document["name"];
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Form(
            key: _reviewFormKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child:  Align(
                    child: Text(
                      "Hotel: " + this._hotelname,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child:  Align(
                    child: Text(
                      "Enter Review",
                      style: TextStyle(fontSize: 25),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child:  TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: "Your Review",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 5)
                    ),
                    validator: (newReviewText) {
                      setState(() {
                        this._review = newReviewText;
                      });
                      if(newReviewText.isEmpty) {
                        return "Please enter your review";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: Container(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Rate the hotel",
                            style: TextStyle(fontSize: 25)
                        )
                    ),

                  ),
                ),
                Container(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Align(
                          alignment: Alignment.center,
                          child: RatingBar(
                            initialRating: this._rating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              this._rating = rating.toInt();
                            },
                            unratedColor: Color(0x66949494),
                          ),
                        )
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: RaisedButton(
                                color: Color(0xFF5CB85C),
                                child: Text("Submit"),
                                onPressed: () {
                                    if(this._reviewFormKey.currentState.validate()) {
                                      createNewReview();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HotelListPage()));
                                    }
                                },
                              ),
                          ),
                        )
                      ),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: RaisedButton(
                                  color: Colors.red,
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HotelListPage()));
                                  },
                                ),
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  createNewReview() {
    Review review = Review(
        hotelName: this._hotelname,
        username: this._username,
        timestampDate: this._timestamp,
        stars: this._rating,
        review: this._review,
        timestampLastEdited: this._timestamp);

    addReview(review);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text("Write a review"),
          ),
          body: buildBody(context)
      )
    );
  }
}
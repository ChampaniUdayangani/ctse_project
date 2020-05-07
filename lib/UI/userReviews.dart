//Coded by S.M.M.K. Subasinghe, IT17134736
//Coded with references from https://api.flutter.dev/flutter/material/AlertDialog-class.html
//Coded with references from https://pub.dev/packages/smooth_star_rating
//Coded with references from https://api.flutter.dev/flutter/widgets/Form-class.html

import 'package:ctse_project/API/reviewAPI.dart';
import 'package:ctse_project/model/review.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'hotelList.dart';

class UserReviewPage extends StatefulWidget {
  @override
  UserReviewState createState() => UserReviewState();
}

class UserReviewState extends State<UserReviewPage> {
  String _username = "Kasun Seneviratne";

  final _editFormKey = GlobalKey<FormState>();
  String _editedReview;
  int _editedRating;

  //Retrieve reviews added by the current user and generate list
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getReviewsPerUser(this._username),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        }
        if(snapshot.hasData) {
          print("Received ${snapshot.data.documents.length} documents");
          return buildList(context, snapshot.data.documents);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  //Build the list view of reviews
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  //Build each item of the list of each review
  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final review = Review.fromSnapshot(data);
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                review.date
                            )
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: buildRating(context, review.stars),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child:  Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Hotel: ' + review.hotelName,
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              )
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                                review.review
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                'Added by you (' + review.username + ')'
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  'Last edited on ' + review.lastEdited
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.bottomRight,
                            child: buildEditButton(context, review)
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: buildDeleteButton(context, review)
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Build the star rating view with the rating given by the user
  Widget buildRating(BuildContext context, int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  //Build edit button of each review
  Widget buildEditButton(BuildContext context, Review review) {
    return Container(
      child: RaisedButton(
        color: Color(0xFF5CB85C),
        child: Icon(Icons.edit),
        onPressed: () {
            buildEditFormWindow(review);
            this._editedRating = review.stars;
        },
      ),
    );
  }

  //Build delete button for each review
  Widget buildDeleteButton(BuildContext context, Review review) {
    return Container(
      child: RaisedButton(
        color: Colors.red,
        child: Icon(Icons.delete),
        onPressed: () {
            deleteReview(review);
        },
      ),
    );
  }

  Future<void> buildEditFormWindow(Review review) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Review"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildForm(context, review)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget buildForm(BuildContext context, Review review) {
    return Form(
      key: _editFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0x5596D4F2),
              hintText: review.review,
              labelText: "Enter new review text here",
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 5)
            ),
            validator: (newReviewText) {
              setState(() {
                this._editedReview = newReviewText;
              });
              if(newReviewText.isEmpty) {
                return "Please enter the new review text";
              }
              return null;
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    child: Text(
                      "Provide new Rating",
                      style: TextStyle(fontSize: 12, color: Colors.indigo),
                    ),
                  )
              ),
              decoration: BoxDecoration(
                color: Color(0x5596D4F2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)
                )
              ),
            ),
          ),
          Container(
              width: 250,
              decoration: BoxDecoration(
                  color: Color(0x5596D4F2)
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Align(
                  alignment: Alignment.center,
                  child: RatingBar(
                    initialRating: this._editedRating.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      this._editedRating = rating.toInt();
                      print(this._editedRating);
                    },
                    unratedColor: Color(0x66949494),
                  ),
                )
              )
          ),
        ],
      ),
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
            title: Text('Your reviews'),
          ),
          body: buildBody(context),
      ),
    );
  }
}
import 'package:ctse_project/API/reviewAPI.dart';
import 'package:ctse_project/model/review.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'hotelList.dart';

class UserReviewPage extends StatefulWidget {
  @override
  UserReviewState createState() => UserReviewState();
}

class UserReviewState extends State<UserReviewPage> {
  String _username = "Kasun Seneviratne";

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
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
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
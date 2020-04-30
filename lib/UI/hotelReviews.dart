//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/API/reviewAPI.dart';
import 'package:ctse_project/UI/addReview.dart';
import 'package:ctse_project/UI/hotelDetails.dart';
import 'package:ctse_project/UI/hotelList.dart';
import 'package:ctse_project/model/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotelReviewPage extends StatefulWidget {
  DocumentSnapshot _receivedDocument;

  //Overloaded constructor for the widget
  HotelReviewPage(DocumentSnapshot document) {
    this._receivedDocument = document;
  }

  @override
  HotelReviewState createState() => HotelReviewState(this._receivedDocument);
}

class HotelReviewState extends State<HotelReviewPage> {
  DocumentSnapshot _document;
  String _hotelname;

  //Overloaded constructor for the state
  HotelReviewState(DocumentSnapshot document) {
    this._document = document;
    this._hotelname = document["name"];
  }

  //Get reviews from the db and generate list of reviews
  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getReviewsPerHotel(_hotelname),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
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

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final review = Review.fromSnapshot(data);
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
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
        )
      )
    );
  }

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
          title: Text('Hotel reviews'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder : (context) => HotelListPage()));
            },
          ),
        ),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddReviewPage(this._document)));
          },
        ),
      ),
    );
  }
}
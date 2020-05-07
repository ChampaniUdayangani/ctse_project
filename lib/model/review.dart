//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Review {
  String username;
  String hotelName;
  int stars;
  String review;
  String date;
  String lastEdited;
  Timestamp timestampDate;
  Timestamp timestampLastEdited;
  DocumentReference reference;

  Review({this.hotelName, this.username, this.timestampDate, this.stars, this.review, this.timestampLastEdited});

  Review.fromMap(Map<String, dynamic> map, {this.reference}){
    timestampDate = map["date"];
    timestampLastEdited = map["lastEdited"];

    username = map["username"];
    hotelName = map["hotelName"];
    stars = map["rating"];
    review = map["review"];
    date = DateFormat("yyyy-MM-dd").format(timestampDate.toDate());
    lastEdited = DateFormat("yyyy-MM-dd").format(timestampLastEdited.toDate());
  }

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {
      "hotelName": hotelName,
      "username": username,
      "date": timestampDate,
      "lastEdited": timestampLastEdited,
      "review": review,
      "rating": stars
    };
  }
}
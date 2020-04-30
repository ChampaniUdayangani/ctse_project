import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Review {
  String username;
  String hotelName;
  int stars;
  String review;
  String date;
  Timestamp timestamp;
  DocumentReference reference;

  Review.fromMap(Map<String, dynamic> map, {this.reference}){
     timestamp = map["date"];

    username = map["username"];
    hotelName = map["hotelName"];
    stars = map["rating"];
    review = map["review"];
    date = DateFormat("yyyy-MM-dd").format(timestamp.toDate());
  }

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/review.dart';

final CollectionReference _reviewCollectionReference = Firestore.instance.collection("reviews");

//Get hotel reviews for each hotel in descending order
getReviewsPerHotel(String hotelName) {
  return _reviewCollectionReference.where('hotelName', isEqualTo: hotelName).orderBy("date", descending: true).snapshots();
}

//Get hotel reviews added by the user (Kasun Seneviratne)
getReviewsPerUser(String username) {
  return _reviewCollectionReference.where('username', isEqualTo: username).snapshots();
}

//Query to add a enw review
addReview(Review review) {
  try {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await _reviewCollectionReference.document().setData(review.toJson());
    });
  } catch(error) {
    print(error.toString());
  }
}

//Delete an existing review added by the user
deleteReview(Review review) {
  Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(review.reference);
    }
  );
}

//Update an existing review added by the user
updateReview(Review review, String newReview, int newRating) {
  Timestamp lastEditedTime = Timestamp.now();

  try {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(review.reference, {'review': newReview, 'rating': newRating, 'lastEdited': lastEditedTime});
    });
  } catch(error) {
    print(error.toString());
  }
}
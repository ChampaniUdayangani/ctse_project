//Coded by S.M.M.K. Subasinghe, IT17134736
//Contains all the APIs used for handling CRUD operations for reviews

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/review.dart';

//Reference for the "reviews" collection
final CollectionReference _reviewCollectionReference = Firestore.instance.collection("reviews");

//Get hotel reviews for each hotel
getReviewsPerHotel(String hotelName) {
  return _reviewCollectionReference.where('hotelName', isEqualTo: hotelName).snapshots();
}

//Get hotel reviews added by the user (Kasun Seneviratne)
getReviewsPerUser(String username) {
  return _reviewCollectionReference.where('username', isEqualTo: username).snapshots();
}

//API used to add a new review into the database
addReview(Review review) {
  try {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await _reviewCollectionReference.document().setData(review.toJson());
    });
  } catch(error) {
    print(error.toString());
  }
}

//API used to delete an existing review from the database
deleteReview(Review review) {
  Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(review.reference);
    }
  );
}

//API used to update an existing review added by the user
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
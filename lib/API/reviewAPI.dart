//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/review.dart';

final CollectionReference _reviewCollectionReference = Firestore.instance.collection("reviews");

getReviewsPerHotel(String hotelName) {
  return _reviewCollectionReference.where('hotelName', isEqualTo: hotelName).snapshots();
}

getReviewsPerUser(String username) {
  return _reviewCollectionReference.where('username', isEqualTo: username).snapshots();
}

addReview() {
    Review review = Review(hotelName: "controller", );
}

deleteReview(Review review) {
  Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.delete(review.reference);
    }
  );
}

updateReview(Review review, String newReview, int newRating) {
  Timestamp lastEditedTime = Timestamp.now();
  print(newReview);
  print(newRating);
  print(lastEditedTime);

  try {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(review.reference, {'review': newReview, 'rating': newRating, 'lastEdited': lastEditedTime});
    });
  } catch(error) {
    print(error.toString());
  }
}
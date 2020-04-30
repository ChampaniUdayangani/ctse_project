//Coded by S.M.M.K. Subasinghe, IT17134736

import 'package:cloud_firestore/cloud_firestore.dart';

getAllReviews(){
  return Firestore.instance.collection("reviews").snapshots();
}

getReviewsPerHotel(String hotelName) {
  return Firestore.instance.collection("reviews").where('hotelName', isEqualTo: hotelName).snapshots();
}

getReviewsPerUser(String username) {
  return Firestore.instance.collection("reviews").where('username', isEqualTo: username).snapshots();
}
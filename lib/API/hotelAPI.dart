/*
IT16023574
Udayangani Hamy W.C.
*/

// hotelAPI.dart

import 'package:cloud_firestore/cloud_firestore.dart';

//get snapshots of the documents
getHotels(){
  return Firestore.instance.collection("hotels").snapshots();
}

//get document by passing document ID
getHotel(String documentID){
  var status;
  Firestore.instance.collection('hotels').document(documentID)
      .get().then((documentSnapshot) => {
    if(documentSnapshot.data == null){
      status = false
    }
    else{
      status = true
    }
  }
  );
  return status;
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';


getBookmarkedHotels(){
  return Firestore.instance.collection('bookmarked').snapshots();
}

getBookmarkHotel(String documentID){
  var status;
  Firestore.instance.collection('bookmarked').document(documentID)
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


addBookmarkedHotels(BookmarkedHotel hotel){
  try{
    Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection("bookmarked")
              .document(hotel.name)
              .setData(hotel.toJson());
        }
    );
  }
  catch(e){
    print(e.toString());
  }
}


deleteBookmarkedHotel(String hotelID){
  Firestore.instance.runTransaction(
      (Transaction transaction) async {
        await Firestore.instance
            .collection("bookmarked")
            .document(hotelID)
            .delete();
      }
  );
}

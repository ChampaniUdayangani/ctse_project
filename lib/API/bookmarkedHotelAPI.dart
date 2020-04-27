import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';


//get document snapshots
getBookmarkedHotels(){
  return Firestore.instance.collection('bookmarked').snapshots();
}

//get document by passing document ID
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

//add new bookmarked hotel to the database
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


//delete already bookmarked hotel from database by passing document ID
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

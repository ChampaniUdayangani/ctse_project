import 'package:cloud_firestore/cloud_firestore.dart';


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
import 'package:cloud_firestore/cloud_firestore.dart';


getHotels(){
  return Firestore.instance.collection("hotels").snapshots();
}


/*
IT16023574
Udayangani Hamy W.C.
*/

// bookMarkedHotel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkedHotel{
  //define all the necessary attributes for BookmarkedHotel
  String name;
  int price;
  String location;
  String bgImg;
  DocumentReference reference;

  //BookmarkedHotel constructor
  BookmarkedHotel({this.name, this.price, this.location, this.bgImg});

  //map data with database reference
  BookmarkedHotel.fromMap(Map<String, dynamic> map, {this.reference}){
    name = map["name"];
    price = map["price"];
    location = map["location"];
    bgImg = map["bg_img"];

  }

  BookmarkedHotel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  //convert document data into JSON format
  toJson(){
        return {'name': name, 'price': price, 'location': location, 'bg_img': bgImg};
  }

}

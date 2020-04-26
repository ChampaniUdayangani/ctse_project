import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkedHotel{
  String name;
  int price;
  String location;
  String bgImg;
  DocumentReference reference;

  BookmarkedHotel(
      {this.name, this.price, this.location, this.bgImg}
      );

  BookmarkedHotel.fromMap(Map<String, dynamic> map, {this.reference}){
    name = map["name"];
    price = map["price"];
    location = map["location"];
    bgImg = map["bg_img"];

  }

  BookmarkedHotel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

    toJson(){
        return {'name': name, 'price': price, 'location': location, 'bg_img': bgImg};
    }


}

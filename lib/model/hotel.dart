import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel{
    //define all the necessary attributes for Hotel
    String name;
    String location;
    List<String> images;
    int price;
    int rating;
    String bg_img;
    String desc;
    List<String> facilities;
    Map<String, double> stats;
    DocumentReference reference;


    //map data with database reference
    Hotel.fromMap(Map<String, dynamic> map, {this.reference}){
        name = map["name"];
        price = map["pricing"];
        rating = map["rating"];
        bg_img = map["bg_img"];
        desc = map["description"];
        images = List.from(map['img']);
        stats = Map.from(map['stats']);
    }

    Hotel.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data, reference: snapshot.reference);

}

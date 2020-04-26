import 'package:ctse_project/API/bookmarkedHotelAPI.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctse_project/API/hotelAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/hotel.dart';

class BookmarkedHotelPage extends StatefulWidget{
  @override
  BookmarkedHotelState createState() => BookmarkedHotelState();

}

class BookmarkedHotelState extends State<BookmarkedHotelPage> {
  

  Widget buildHotelList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      shrinkWrap: true,
      children: snapshot.map((data) => buildListItem(context, data)).toList(),

    );
  }


  Widget buildListItem(BuildContext context, DocumentSnapshot data){
    final hotel = BookmarkedHotel.fromSnapshot(data);
    return Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 80/100,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: <Widget>[
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage(hotel.bgImg),
                    fit: BoxFit.fill,
                  ),
                  Container(
                    child: Expanded(
                        child: Column(
                          children: <Widget>[
                            Text(
                              hotel.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              hotel.location,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              'LKR '+ hotel.price.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                    )
                  )
                ],
              ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                deleteBookmarkedHotel(hotel.name);
              }
          )
        ],
      )
    );
      

  }


  Widget buildStarRatings(BuildContext context, int count){
    final children = <Widget>[];
    for (var i = 0; i < count; i++) {
      children.add(new Icon(Icons.star, color: Colors.yellow));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
  

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Hotel Booking App',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Bookmarked Hotels'),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: getBookmarkedHotels(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return const Text('Loading');
                return ListView(
                  children: <Widget>[
                    buildHotelList(context, snapshot.data.documents)
                  ],
                );
              }
          )
      ),
    );
  }









}


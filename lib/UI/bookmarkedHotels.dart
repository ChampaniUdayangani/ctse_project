/*
IT16023574
Udayangani Hamy W.C.
*/

// bookmarkedHotels.dart

import 'package:ctse_project/API/bookmarkedHotelAPI.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkedHotelPage extends StatefulWidget{
  @override
  BookmarkedHotelState createState() => BookmarkedHotelState();

}


//Referred https://flutter.dev/docs
class BookmarkedHotelState extends State<BookmarkedHotelPage> {
  
  //generate bookmarked hotel list
  Widget buildHotelList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      shrinkWrap: true,
      children: snapshot.map((data) => buildListItem(context, data)).toList(),

    );
  }

  //generate each bookmarked hotel list item
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
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                hotel.name,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                hotel.location,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.brown,
                                  ),
                                  Text(
                                    'LKR '+ hotel.price.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    )
                  )
                ],
              ),
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                size: 30.0,
                color: Colors.black54,
              ),
              onPressed: (){
                deleteBookmarkedHotel(hotel.name);
              }
          )
        ],
      )
    );
      

  }


  //override build method
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
          primaryColor: Colors.indigo
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Bookmarked Hotels'),
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: getBookmarkedHotels(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return
                  Center(
                    child: CircularProgressIndicator(),
                  ) ;
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


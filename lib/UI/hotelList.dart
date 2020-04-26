import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctse_project/API/hotelAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/hotel.dart';
import 'package:ctse_project/UI/hotelDetails.dart';

class HotelListPage extends StatefulWidget{
  @override
  HotelListState createState() => HotelListState();

}

class HotelListState extends State<HotelListPage> {

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
        stream: getHotels(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Error ${snapshot.error}');
          }
          if(snapshot.hasData){
            print('Documents ${snapshot.data.documents.length}');
            return Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Popular Hotels',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  popularHotelSection(context, snapshot.data.documents),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                        child: Text(
                            'Explore More',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      )
                  ),
                  Expanded(
                      child: buildHotelList(context, snapshot.data.documents)
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }

  Widget buildHotelList(BuildContext context, List<DocumentSnapshot> snapshots){
      return ListView(
        shrinkWrap: true,
        children: snapshots.map((data) => buildListItem(context, data)).toList(),
      );
  }



  Widget buildListItem(BuildContext context, DocumentSnapshot data){
    final hotel = Hotel.fromSnapshot(data);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailedPage(),
            settings: RouteSettings(
              arguments: data,
            ),
          ),
        );
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Row(
          children: <Widget>[
            Image(
              height: 140,
              width: 100,
              image: AssetImage(hotel.bg_img),
              fit: BoxFit.fill,
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 2.0, right: 2.0),
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
                      buildStarRatings(context, hotel.rating),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(hotel.desc),
                      )
                    ],
                  ),
                )
            )
          ],
        ),

      ),
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


  Widget popularHotelSection(BuildContext context, List<DocumentSnapshot> documents){
    print(documents.length);
    final popularHotels = <DocumentSnapshot>[];
    for(var count = 0; count < documents.length; count++){
      if(documents[count]['popularity'] > 6){
        popularHotels.add(documents[count]);
      }
    }

    return Container(
      child: Container(
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: popularHotels.map((document) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetailedPage(),
                    settings: RouteSettings(
                      arguments: document,
                    ),
                  ),
                );
              },

              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: _buildStack(document),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                margin: EdgeInsets.all(5.0),
              ),
            )
            ).toList(),
          )

      ),
    );


  }


  Widget _buildStack(DocumentSnapshot document){
    Hotel hotel = Hotel.fromSnapshot(document);
    return Stack(
      alignment: const Alignment(0.6, 0.6),
      children: [
        Image(
          width: 400,
          height: 200,
          image: AssetImage(document['bg_img']),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 110.0, left: 150.0),
          child: Row(
//            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Text(
                hotel.rating.toString() + '.0',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.star,
                size: 18.0,
                color: Colors.white,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
              padding: EdgeInsets.only(bottom: 10.0, left: 5.0),
              child: Text(
                document['name'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
          )
        ),
      ],
    );
  }







  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Hotel Booking App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hotels'),
        ),
        body: buildBody(context)
      ),
    );
  }









}


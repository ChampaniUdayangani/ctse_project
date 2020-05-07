/*
IT16023574
Udayangani Hamy W.C.
*/

// hotelDetails.dart

import 'dart:async';

import 'package:ctse_project/UI/bookmarkedHotels.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ctse_project/API/bookmarkedHotelAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/hotel.dart';
import 'package:ctse_project/custom/circularProgress.dart';
import 'package:geocoder/geocoder.dart';


//Referred https://flutter.dev/docs
class HotelDetailedPage extends StatefulWidget{
  @override
  HotelState createState() => HotelState();

}



class HotelState extends State<HotelDetailedPage> {
  //create bookmarked hotel set
  final _bookmarkedHotels = Set<String>();

  //define controller for google map
  static Completer<GoogleMapController> _controller = Completer();

  //_onMapCreated method for google map
  static void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  
  //generate slider to display hotel images
  Widget buildHotelImageSliderSection(BuildContext context, DocumentSnapshot document){
    Hotel hotel = Hotel.fromSnapshot(document);

    //create new BookmarkedHotel
    BookmarkedHotel bookmarked = new BookmarkedHotel(
        name: document['name'],
        price: document['pricing'],
        location: document['location'],
        bgImg: document['bg_img'],
    );

    /*
    check whether the hotel is already saved
    this is used to add and delete bookmarked hotels when user clicks on bookmark icon
     */
    final alreadySaved = _bookmarkedHotels.contains(bookmarked.name);

    return Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          options: CarouselOptions(

          ),
          items: document["img"].map<Widget>((item) => Container(
            child: Stack(
                children: [
                  Image(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    image: AssetImage(item),
                    fit: BoxFit.fill,
                  ),
                  Container(
                      child: ListTile(
                        trailing: Icon(alreadySaved ? Icons.bookmark : Icons.bookmark_border,
                          color: alreadySaved ? Colors.red : null,
                          size: 34.0,
                        ),
                        onTap: (){
                          setState(() {
                            if(alreadySaved){
                              deleteBookmarkedHotel(bookmarked.name);
                              _bookmarkedHotels.remove(bookmarked.name);

                            }
                            else{
                              addBookmarkedHotels(bookmarked);
                              _bookmarkedHotels.add(bookmarked.name);
                            }
                          });
                        },
                      )
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      hotel.name,
                      style: TextStyle(
                      fontSize: 35.0,
                      color: Colors.white,
                    ),
                    ),
                  )
                ]
            ),
          )
          ).toList(),
        )
    );
  }


  //generate circular progress bar for each service using flutter animations
  Padding buildPercentageViewer(BuildContext context, stat) {

    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Center(
            child: CustomPaint(
              foregroundPainter: CircularProgress(stat.value),
              child: Container(
                width: 80,
                height: 80,
                child: Center(child: Text((stat.value/10).toStringAsFixed(1)),),
              ),
            ),
          ),
          Text(
            stat.key,
            style: TextStyle(
                fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  //generate hotel service ratings list
  Widget statsSection(BuildContext context, DocumentSnapshot document){
    final children = <Widget>[];

    for (var entry in document["stats"].entries) {
      children.add(buildPercentageViewer(context, entry));
    }

    return Container(
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  'Stats',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
              )
          ),
          Row(
              children: children
          )
        ],
      )
    );
  }


  //generate hotel description
  Widget descriptionSection(BuildContext context, DocumentSnapshot document){
    Hotel hotel = Hotel.fromSnapshot(document);
     return Container(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
              child: Text(
                'Description',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              hotel.desc,
              softWrap: true,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          )
        ],
      ),
    );
  }


  //generate hotel facilities list using Flutter icons
  Widget facilitiesSection(BuildContext context, DocumentSnapshot document){
    var icon;
    final children = <Widget>[];
    final List<dynamic> facilities = document['facilities'];
    for (var i=0; i<facilities.length; i++) {
      switch(facilities[i]) {
        case "Wifi": {
          icon = Icon(
            Icons.wifi,
            color: Colors.teal,
            size: 40.0,
          );
        }
        break;
        case "Pets": {
          icon = Icon(
            Icons.pets,
            color: Colors.brown,
            size: 40.0,
          );
        }
        break;
        case "Breakfast": {
          icon = Icon(
            Icons.fastfood,
            color: Colors.amber,
            size: 40.0,
          );
        }
        break;
        case "Parking": {
          icon = Icon(
            Icons.local_parking,
            color: Colors.blueGrey,
            size: 40.0,
          );
        }
        break;
        case "Pool": {
          icon = Icon(
            Icons.pool,
            color: Colors.lightBlue,
            size: 40.0,
          );
        }
        break;
        case "Spa": {
          icon = Icon(
            Icons.spa,
            color: Colors.green,
            size: 40.0,
          );
        }
        break;
        case "Luxurious Vibe": {
          icon = Icon(
            Icons.local_activity,
            color: Colors.red,
            size: 40.0,
          );
        }
        break;
        default: {
          icon = Icon(
            Icons.card_giftcard,
            color: Colors.pink,
            size: 40.0,
          );
        }
        break;
      }
      children.add(buildFacilityIcon(Colors.blue, icon, facilities[i]));
    }

    return Container(
      child:
      Column(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Text(
                  'Facilities',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
                  ),
                ),
              )
          ),
          Row(
              children: children
          ),
        ],
      )

    );
  }


  //generate individual hotel facility icon
  Padding buildFacilityIcon(Color color, Icon icon, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          icon,
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: color
              ),
            ),
          ),
        ],
      ),
    );


  }

  /*
  get the latitude and longitude of hotel address
  this is used to display the marker on map
   */
  Future<LatLng> _getLocation(String address) async{

    var location = await Geocoder.local.findAddressesFromQuery(address);
    LatLng cords = LatLng(location.first.coordinates.latitude, location.first.coordinates.longitude);
    return cords;

  }

   //display the map and include location marker on hotel address
   Widget googleMapSection(BuildContext context, DocumentSnapshot document) {
     Set<Marker> _markers = {};
     LatLng _hotelPosition;
    return FutureBuilder(
        future: _getLocation(document['location']),
        builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot){
          if(snapshot.hasData){
            _hotelPosition = snapshot.data;
            _markers.add(Marker(
               //set marker id as location address which uniquely identifies the marker.
               markerId: MarkerId(document['location']),
               position: _hotelPosition,
               infoWindow: InfoWindow(
                 title: document['location'],
                 snippet: document['rating'].toString()+' star rating',
               ),
               icon: BitmapDescriptor.defaultMarker,
             ));

            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: GoogleMap(
                    markers: _markers,
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _hotelPosition,
                      zoom: 12.0,
                    ),
                  )
                )
              ],
            );
          }
          return CircularProgressIndicator();
        }
    );

  }

  //display the hotel price
  Align buildPriceSection(BuildContext context, DocumentSnapshot document){
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'LKR '+ document['pricing'].toString(),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }



  //display the star ratings of the hotel
  Widget buildStarRatings(BuildContext context, DocumentSnapshot document){
    int rating = document['rating'];
    final children = <Widget>[];
    for (var i = 0; i < rating; i++) {
      children.add(new Icon(Icons.star, color: Colors.yellow, size: 24.0,));
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: children
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Text(
                  'Recommended By ',
                  style: TextStyle(
                    fontSize: 18.0
                  ),
                ),
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.deepPurple,
                  size: 28.0,
                ),
                Text(
                  ' '+ document['recommends'] + '+ people',
                  style: TextStyle(
                      fontSize: 18.0
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  size: 20.0,
                  color: Colors.blueGrey,

                ),
                Text(
                  document['telephone'],
                  style: TextStyle(
                      fontSize: 18.0
                  ),
                ),
              ],
            )
          )
        ]
        
      ),
    );
  }


  //generate main content of the UI
  Widget buildBody(BuildContext context){
    final DocumentSnapshot hotel = ModalRoute.of(context).settings.arguments;

    return ListView(
      children: <Widget>[
        buildHotelImageSliderSection(context, hotel),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              buildPriceSection(context, hotel),
              buildStarRatings(context, hotel),
              descriptionSection(context, hotel),
              googleMapSection(context, hotel),
              facilitiesSection(context, hotel),
              statsSection(context, hotel),
            ],
          ) ,
        )
      ],
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
            title: Text('Hotel Details'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkedHotelPage()),
                    );
                  }
                  )
            ],
          ),
          body: buildBody(context)
      ),
    );
  }
}
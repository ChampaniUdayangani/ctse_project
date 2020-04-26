import 'dart:async';

import 'package:ctse_project/UI/bookmarkedHotels.dart';
import 'package:ctse_project/model/bookMarkedHotel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ctse_project/API/hotelAPI.dart';
import 'package:ctse_project/API/bookmarkedHotelAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_project/model/hotel.dart';
import 'package:ctse_project/custom/circularProgress.dart';
import 'package:geocoder/geocoder.dart';



class HotelDetailedPage extends StatefulWidget{
  @override
  HotelState createState() => HotelState();

}



class HotelState extends State<HotelDetailedPage> {
  final _bookmarkedHotels = Set<String>();

  static Completer<GoogleMapController> _controller = Completer();


  static void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  

  Widget buildHotelImageSliderSection(BuildContext context, DocumentSnapshot document){
    Hotel hotel = Hotel.fromSnapshot(document);

    BookmarkedHotel bookmarked = new BookmarkedHotel(
        name: document['name'],
        price: document['pricing'],
        location: document['location'],
        bgImg: document['bg_img'],
    );
    final alreadySaved = _bookmarkedHotels.contains(bookmarked.name);
    print(alreadySaved);

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
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    image: AssetImage(item),
                    fit: BoxFit.fill,
                  ),
                  Container(
                      child: ListTile(
                        trailing: Icon(alreadySaved ? Icons.bookmark : Icons.bookmark_border,
                          color: alreadySaved ? Colors.green : null,
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
                      fontSize: 20.0,
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


  Padding buildPercentageViewer(BuildContext context, stat) {

    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 5.0),
      child: Column(
        children: <Widget>[
          Center(
            child: CustomPaint(
              foregroundPainter: CircularProgress(stat.value),
              child: Container(
                width: 70,
                height: 70,
                child: Center(child: Text((stat.value/10).toStringAsFixed(1)),),
              ),
            ),
          ),
          Text(stat.key)
        ],
      ),
    );
  }

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
                    fontSize: 20.0,
                  ),
                ),
              )
          ),
          Row(
//          mainAxisAlignment: MainAxisAlignment.start,
              children: children
          )
        ],
      )

    );
  }


  Widget descriptionSection(BuildContext context, DocumentSnapshot document){
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
                  fontSize: 20.0,
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              document['description'],
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }


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
            size: 34.0,
          );
        }
        break;
        case "Pets": {
          icon = Icon(
            Icons.pets,
            color: Colors.brown,
            size: 34.0,
          );
        }
        break;
        case "Breakfast": {
          icon = Icon(
            Icons.fastfood,
            color: Colors.amber,
            size: 34.0,
          );
        }
        break;
        case "Parking": {
          icon = Icon(
            Icons.local_parking,
            color: Colors.blueGrey,
            size: 34.0,
          );
        }
        break;
        case "Pool": {
          icon = Icon(
            Icons.pool,
            color: Colors.lightBlue,
            size: 34.0,
          );
        }
        break;
        case "Spa": {
          icon = Icon(
            Icons.spa,
            color: Colors.green,
            size: 34.0,
          );
        }
        break;
        case "Luxurious Vibe": {
          icon = Icon(
            Icons.local_activity,
            color: Colors.red,
            size: 34.0,
          );
        }
        break;
        default: {
          icon = Icon(
            Icons.card_giftcard,
            color: Colors.pink,
            size: 34.0,
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
                    fontSize: 20.0,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: color
              ),
            ),
          ),
        ],
      ),
    );


  }

  Future<LatLng> _getLocation(String address) async{

    var location = await Geocoder.local.findAddressesFromQuery(address);
    LatLng cords = LatLng(location.first.coordinates.latitude, location.first.coordinates.longitude);
    return cords;

  }


   Widget googleMapSection(BuildContext context, DocumentSnapshot document) {
      const LatLng _center = const LatLng(7.5328897, 79.841951);
      final Set<Marker> _markers = {};
      LatLng _hotelPosition;
      _getLocation(document['location']).then((LatLng coordinates){
        _hotelPosition = coordinates;
      });

      _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(document['location']),
        position: _hotelPosition,
        infoWindow: InfoWindow(
          title: document['location'],
          snippet: document['rating'].toString()+' star rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    return Container(
        height: 200,
        child: GoogleMap(
          markers: _markers,
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12.0,
          ),
        )
    );
  }

  Align buildPriceSection(BuildContext context, DocumentSnapshot document){
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'LKR '+ document['pricing'].toString(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),


      ),
    );
  }


  Widget buildStarRatings(BuildContext context, DocumentSnapshot document){
    int rating = document['rating'];
    final children = <Widget>[];
    for (var i = 0; i < rating; i++) {
      children.add(new Icon(Icons.star, color: Colors.yellow, size: 20.0,));
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
                Text('Recommended By '),
                Icon(
                  Icons.supervised_user_circle,
                  color: Colors.deepPurple,
                ),
                Text(document['recommends'] + '+ people'),
              ],
            ),

          )
        ]
        
      ),
    );
  }

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

//      StreamBuilder<QuerySnapshot>(
//        stream: getHotels(),
//        builder: (context, snapshot){
//          if(!snapshot.hasData) return const Text('Loading');
//          return
//        }
//    );
  }

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: 'Hotel Booking App',
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
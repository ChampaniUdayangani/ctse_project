//Coded by S.M.M.K. Subasinghe, IT17134736
//Coded with references from https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation

import 'package:flutter/material.dart';

import 'package:ctse_project/UI/hotelList.dart';
import 'package:ctse_project/UI/bookmarkedHotels.dart';
import 'package:ctse_project/UI/userReviews.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _pageIndex = 0;
  final List<Widget> _widgetList = [HotelListPage(), BookmarkedHotelPage(), UserReviewPage()];

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primaryColor: Colors.indigo
      ),
      home: Scaffold(
        body: _widgetList[_pageIndex],
        bottomNavigationBar: BottomNavigationBar (
          onTap: onTabTapped,
          currentIndex: _pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text('Home')
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.bookmark),
                title: new Text('Bookmarks')
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.chat_bubble),
                title: new Text('Reviews')
            )
          ],
        ),
      )
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
}
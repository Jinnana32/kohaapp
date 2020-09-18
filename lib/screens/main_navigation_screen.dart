import 'package:flutter/material.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/screens/home_screen.dart';
import 'package:kohaapp/screens/profile_screen.dart';
import 'package:kohaapp/screens/reserve_screen.dart';

class MainNavigationScreen extends StatelessWidget {

  Profile mProfile;

  MainNavigationScreen({Key key, @required this.mProfile}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koha library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white
      ),
      home: NavigationBar(mProfile: this.mProfile),
    );
  }

}


class NavigationBar extends StatefulWidget {

  Profile mProfile;

  NavigationBar({Key key, @required this.mProfile}) : super(key: key);

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBar> {

  int _currentIndex = 0;
  List<Widget> _screens = [];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    _screens = [
      HomeScreen(mProfile: widget.mProfile),
      ReserveScreen(mProfile: widget.mProfile),
      ProfileScreen(mProfile: widget.mProfile)
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onItemTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Home")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_drive_file),
                title: Text("Reservation")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                title: Text("Profile")
            )
          ]),
    );
  }

}

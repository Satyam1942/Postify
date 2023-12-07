import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/home_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selectedIndex =0;
  static final List<Widget> widgetOptions= <Widget>[

    const Text ("Home"),
    const Text("Search"),
    const Text("Friends"),
    const Text("Profile")

  ];

  void onItemTapped(int index)
  {
    setState(() {
      selectedIndex = index;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

  body: Center(
    child: widgetOptions[selectedIndex],
  ),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: onItemTapped,
  //  type: BottomNavigationBarType.fixed,
    elevation: 10,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.deepPurple,
    items: [
    BottomNavigationBarItem(icon:Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon:Icon(Icons.search) ,label: "Search"),
    BottomNavigationBarItem(icon:Icon(Icons.people_alt_rounded), label: "Friends"),
    BottomNavigationBarItem(icon:Icon(Icons.person), label: "Profile")
  ],

  ),
    );
  }
}

/// 옮기기 가능
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
//import 'package:client/memorial/watch_others.dart';
import 'home.dart';
import 'memorial/memorial_main.dart';
import 'memorial/watch_others.dart';
import 'mypage/mypage_main.dart';
import 'main.dart' as main;
//import 'memorial/memorial_main0919.dart';


class MyScreenPage extends StatefulWidget {
  const MyScreenPage({super.key, required this.title});

  final String title;

  @override
  State<MyScreenPage> createState() => _MyScreenPageState();
}

class _MyScreenPageState extends State<MyScreenPage> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MemorialMainPage(),
    WatchOthersPage(),
    MypagePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceData = MediaQuery.of(context);
    Size screenSize = deviceData.size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:
      Container(
        height: 72,
        width: screenSize.width,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // backgroundColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/bottom_navigation/home.png')),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/bottom_navigation/gallery.png')),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/bottom_navigation/feed.png')),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/bottom_navigation/my_page.png')),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          // unselectedIconTheme: IconThemeData(
          //     color: Color(0xffD6CEFF),
          //     opacity: 0.5),
          unselectedItemColor: Color(0xffC0D2FC),
          selectedItemColor: Color(0xff83A8FF),
          unselectedIconTheme: IconThemeData(
              shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset.zero)],
              opacity: 1.0),
          selectedIconTheme: IconThemeData(
              shadows: [Shadow(blurRadius: 3, color: Colors.black, offset: Offset.zero)],
              opacity: 100),
          onTap: _onItemTapped,
        ),
      )
    );
  }
}
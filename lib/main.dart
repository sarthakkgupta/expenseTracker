import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './homepage.dart';
import './calendarpage.dart';
import 'dart:io';

import 'models/transaction.dart';



final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
//final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
void main() {
  Platform.isIOS
      ? runApp(
          new CupertinoApp(
            home: HomeScreen(),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
          ),
        )
      : runApp(MyApp());
}
 final List<Transaction> userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      image: null,
      comment: "hahahahahahahahahahahahaha",
      date: DateTime.now(),
    ),
  ];

class HomeScreen extends StatefulWidget {
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text('Stats'),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          if (index == 0 || index==null) {
            return CupertinoTabView(
              navigatorKey: firstTabNavKey,
              builder: (BuildContext context) => MyHomePage(userTransactions),
            );
          } else {
            return CupertinoTabView(
              navigatorKey: secondTabNavKey,
              builder: (BuildContext context) => CalendarPage(userTransactions),
            );
          }
        });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsScreen(),
      routes: {
        ///  '/': (BuildContext context) => AuthPage(),
        ///  '/home': (BuildContext context) => TabsScreen(),
        //  '/signup':  (BuildContext context) => SignUpPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}


class _TabsScreenState extends State<TabsScreen> {
   
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
   final List<Widget> _pages = [MyHomePage(userTransactions), CalendarPage(userTransactions)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedPageIndex]),
      bottomNavigationBar: BottomNavigationBar(
          onTap:  _selectPage,
          currentIndex: _selectedPageIndex,
         
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('main')),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle), title: Text('stats')),
    
          ]),
    );
  }
}

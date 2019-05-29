import 'package:flutter/material.dart';
import './timer_service.dart';
import './pages/home_page.dart';
import './pages/log_page.dart';
import './pages/login_page.dart';
import './pages/manual_page.dart';

void main() {
  final timerService = TimerService();
  runApp(
    TimerServiceProvider(
      // provide timer service to all widgets of your app
      service: timerService,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    LogPage(),
    ManualPage(),
    LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          centerTitle: true,
        ),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.black26,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text('Time Tracking'),
              icon: Icon(Icons.timer),
            ),
            BottomNavigationBarItem(
              title: Text('Log'),
              icon: Icon(Icons.view_list),
            ),
            BottomNavigationBarItem(
              title: Text('Register Manually'),
              icon: Icon(Icons.keyboard),
            ),
            BottomNavigationBarItem(
              title: Text('Login'),
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}

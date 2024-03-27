import 'package:flutter/material.dart';

// My Widgets

import 'Chats/chats_page.dart';
import 'Posts/posts_page.dart';
import 'users/users_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //* Theme
  bool _isDarkTheme = false;
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  //* Navegation
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    PostPage(),
    UsersPage(),
    ChatsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookie Beta for Stadistics ',
      theme: _isDarkTheme
          ? ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black)
          : ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
          title: const Text('Cookie'),
          actions: [
            IconButton(
              icon:
                  Icon(_isDarkTheme ? Icons.brightness_7 : Icons.brightness_3),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDarkTheme
                      ? const Color(0xFF111111)
                      : const Color.fromARGB(255, 243, 243, 243),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.post_add),
              ),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDarkTheme
                      ? const Color(0xFF111111)
                      : const Color.fromARGB(255, 243, 243, 243),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people),
              ),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDarkTheme
                      ? const Color(0xFF111111)
                      : const Color.fromARGB(255, 243, 243, 243),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat),
              ),
              label: 'Chats',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

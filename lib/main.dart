import 'package:flutter/material.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenProvider.dart';
import 'package:useful_app/views/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new HomeScreenProvider(
      child: new MaterialApp(
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomeScreen(),
      ),
    );
  }
}


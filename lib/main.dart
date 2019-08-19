import 'package:flutter/material.dart';
import 'package:useful_app/blocs/providers.dart';
import 'package:useful_app/views/activities_screen.dart';
import 'package:useful_app/views/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Providers(
      child: new MaterialApp(
        theme: new ThemeData(
          fontFamily: "Mali"
        ),
        home: new HomeScreen(),
        routes: <String, WidgetBuilder> {
          HomeScreen.TAG : (BuildContext context) => HomeScreen(),
          ActivitiesScreen.tag : (BuildContext context) => ActivitiesScreen()
        },
      ),
    );
  }
}


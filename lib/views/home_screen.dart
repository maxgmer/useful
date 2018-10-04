import 'package:flutter/material.dart';
import 'package:useful_app/blocs/blocProviders/UserDataProvider.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "HomeScreen";

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {
  int _pageId = 0;

  @override
  Widget build(BuildContext context) {
    final userBloc = HomeScreenProvider.of(context);
    final sessionBloc = Session
    return new Scaffold(
      body: new Container(
        padding: EdgeInsets.all(_HomeScreenValues.SCREEN_PADDING),
        color: _HomeScreenValues.getBackgroundColor(_pageId),
        constraints: BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/images/healthPageSymbol.png"),
              height: _HomeScreenValues.mainImageDims,
              fit: BoxFit.fitHeight,
            ),
            new Text(data)
          ],
        ),
      ),
    );
  }

  void goToNextScreen() {
    if (_pageId < _HomeScreenValues._MAX_PAGE_ID) {
      setState(() => _pageId++);
    } else {
      setState(() => _pageId = 0);
    }
    print("${HomeScreen.TAG} current page is $_pageId");
  }

  void goToPreviousScreen() {
    if (_pageId > 0) {
      setState(() => _pageId--);
    } else {
      setState(() => _pageId = _HomeScreenValues._MAX_PAGE_ID);
    }
    print("${HomeScreen.TAG} current page is $_pageId");
  }
}

class _HomeScreenValues {
  static const int _MAX_PAGE_ID = 3;

  static const double SCREEN_PADDING = 50.0;
  static const double mainImageDims = 144.0;

  static getBackgroundColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(184, 240, 119, 1.0);//Color.fromRGBO(138, 194, 73, 1.0);
      case 1: return Color.fromRGBO(1, 1, 0, 1.0);
      case 2: return Color.fromRGBO(1, 0, 1, 1.0);
      case 3: return Color.fromRGBO(1, 0, 0, 1.0);
    }
  }
}
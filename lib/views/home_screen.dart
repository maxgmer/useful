import 'package:flutter/material.dart';
import 'package:useful_app/blocs/blocProviders/HomeScreenProvider.dart';
import 'package:useful_app/blocs/HomeScreenBloc.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "HomeScreen";

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    final homeScreenBloc = HomeScreenProvider.getBloc(context);
    return new Scaffold(
      body: new StreamBuilder<int>(
          stream: homeScreenBloc.pageId,
          initialData: 0,
          builder: (context, snapshot) {
            return new Container(
              padding: EdgeInsets.all(HomeScreenValues.SCREEN_PADDING),
              color: HomeScreenValues.getBackgroundColor(snapshot.data),
              constraints: BoxConstraints.expand(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Image(
                    image: new AssetImage("assets/images/healthPageSymbol.png"),
                    height: HomeScreenValues.mainImageDims,
                    fit: BoxFit.fitHeight,
                  ),
                  new StreamBuilder<int>(
                      stream: homeScreenBloc.healthLvl,
                      initialData: 1,
                      builder: (context, snapshot) {
                        return new RaisedButton(
                            child: new Text("${snapshot.data}"),
                            onPressed: () {
                              homeScreenBloc.pageIdSink.add(snapshot.data + 1);
                            }
                        );
                      }
                      )
                ],
              ),
            );
          }
          ),
    );
  }
}
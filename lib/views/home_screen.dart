import 'package:flutter/material.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenProvider.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "HomeScreen";

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    final homeScreenBloc = HomeScreenProvider.getBloc(context);
    return Scaffold(
      body: StreamBuilder<int>(
          stream: homeScreenBloc.pageId,
          builder: (context, snapshotPageId) {
            return Container(
              padding: EdgeInsets.all(HomeScreenValues.SCREEN_PADDING),
              color: HomeScreenValues.getBackgroundColor(snapshotPageId.data),
              constraints: BoxConstraints.expand(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/healthPageSymbol.png"),
                    height: HomeScreenValues.MAIN_IMG_DIMS,
                    fit: BoxFit.fitHeight,
                  ),
                  StreamBuilder<String>(
                      stream: homeScreenBloc.getLvlStreamForPage(snapshotPageId.data),
                      builder: (context, snapshotLvlHeader) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(HomeScreenValues.LVL_TITLE_PADDING),
                            child: Text(
                              snapshotLvlHeader.data,
                              style: TextStyle(
                                fontSize: HomeScreenValues.lvlTitleFontSize
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ],
              ),
            );
          }
          ),
    );
  }
}
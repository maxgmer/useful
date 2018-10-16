import 'package:flutter/material.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenProvider.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';
import 'package:useful_app/customWidgets/BreathingImage.dart';
import 'dart:math';

import 'package:useful_app/customWidgets/CustomFAB.dart';
import 'package:useful_app/customWidgets/StatsGraph.dart';
import 'package:useful_app/util/ColorHelper.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "HomeScreen";

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    final homeScreenBloc = HomeScreenProvider.getBloc(context);
    return StreamBuilder<int>(
        stream: homeScreenBloc.pageId,
        builder: (context, pageId) {
          if (pageId.data != null)
          return Scaffold(
              floatingActionButton: CustomFloatingActionButton(() => homeScreenBloc.pageIdSink.add(pageId.data + 1)),
              body: Container(
                padding: EdgeInsets.all(HomeScreenValues.SCREEN_PADDING),
                color: HomeScreenValues.getBackgroundColor(pageId.data),
                constraints: BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    BreathingImage(
                        AssetImage(BreathingImageValues.getImagePath(pageId.data)),
                        size: BreathingImageValues.MAIN_IMG_SIZE
                    ),
                    StreamBuilder<String>(
                        stream: homeScreenBloc.getLvlStreamForPage(pageId.data),
                        builder: (context, textLvlHeader) {
                          if (textLvlHeader.hasData)
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(HomeScreenValues.LVL_TITLE_PADDING),
                                child: Text(
                                  textLvlHeader.data,
                                  style: TextStyle(fontSize: HomeScreenValues.LVL_TITLE_FONT_SIZE),
                                ),
                              ),
                            ); else return Text("How are you bro? xD", style: TextStyle(fontSize: HomeScreenValues.LVL_TITLE_FONT_SIZE));
                        },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: StatsGraphValues.PADDING_TOP),
                      child: StatsGraph(
                        graphMarkupColor: ColorHelper.darken(HomeScreenValues.getBackgroundColor(pageId.data), StatsGraphValues.MARKUP_COLOR_DARKEN_VALUE),
                      ),
                    )
                  ],
                ),
              )
          ); else return Text("HELLO!", style: TextStyle(fontSize: HomeScreenValues.LVL_TITLE_FONT_SIZE));
        },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenProvider.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';
import 'dart:math';

import 'package:useful_app/customWidgets/CustomFAB.dart';

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
      floatingActionButton: StreamBuilder<int>(
          stream: homeScreenBloc.pageId,
          builder: (context, pageId) {
            return CustomFloatingActionButton(() =>
                homeScreenBloc.pageIdSink.add(pageId.data + 1));
          }
      ),
      body: StreamBuilder<int>(
          stream: homeScreenBloc.pageId,
          builder: (context, pageId) {
            return Container(
              padding: EdgeInsets.all(HomeScreenValues.SCREEN_PADDING),
              color: HomeScreenValues.getBackgroundColor(pageId.data),
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
                      stream: homeScreenBloc.getLvlStreamForPage(pageId.data),
                      builder: (context, textLvlHeader) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(HomeScreenValues.LVL_TITLE_PADDING),
                            child: Text(
                              textLvlHeader.data,
                              style: TextStyle(
                                fontSize: HomeScreenValues.LVL_TITLE_FONT_SIZE
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: HomeScreenValues.PAGE_DETAILS_ROW_PADDING, right: HomeScreenValues.PAGE_DETAILS_ROW_PADDING),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: HomeScreenValues.INSIDE_PAGE_DETAILS_ROW_PADDING, right: HomeScreenValues.INSIDE_PAGE_DETAILS_ROW_PADDING),
                          child: Icon(
                              Icons.trending_up,
                              size: HomeScreenValues.PAGE_DETAILS_ROW_IMG_DIMS
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: HomeScreenValues.INSIDE_PAGE_DETAILS_ROW_PADDING, right: HomeScreenValues.INSIDE_PAGE_DETAILS_ROW_PADDING),
                          child: Icon(
                              Icons.payment,
                              size: HomeScreenValues.PAGE_DETAILS_ROW_IMG_DIMS
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[

                    ],
                  )
                ],
              ),
            );
          }
          ),
    );
  }
}
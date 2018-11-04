import 'package:flutter/material.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenProvider.dart';
import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';
import 'package:useful_app/customWidgets/BreathingImage.dart';
import 'dart:math';

import 'package:useful_app/customWidgets/CustomFAB.dart';
import 'package:useful_app/customWidgets/StatsGraph.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/ColorHelper.dart';
import 'package:useful_app/util/WidgetValues.dart';

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
        initialData: homeScreenBloc.initialPageId,
        builder: (context, pageId) {
          return Scaffold(
              floatingActionButton: CustomFloatingActionButton(() => homeScreenBloc.pageIdSink.add(pageId.data + 1)),
              body: Container(
                padding: EdgeInsets.all(HomeScreenValues.SCREEN_PADDING),
                color: HomeScreenValues.getBackgroundColor(pageId.data),
                constraints: BoxConstraints.expand(),
                child: StreamBuilder<List<Activity>>(
                  stream: homeScreenBloc.activities,
                  initialData: homeScreenBloc.initialActivities,
                  builder: (context, activities) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        BreathingImage(
                            AssetImage(BreathingImageValues.getImagePath(pageId.data)),
                            size: BreathingImageValues.MAIN_IMG_SIZE
                        ),
                        StreamBuilder<String>(
                          stream: homeScreenBloc.getLvlStream(pageId.data),
                          initialData: homeScreenBloc.initialLvlHeaderText,
                          builder: (context, textLvlHeader) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(HomeScreenValues.LVL_TITLE_PADDING),
                                child: Text(
                                  textLvlHeader.data,
                                  style: TextStyle(fontSize: HomeScreenValues.LVL_TITLE_FONT_SIZE),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ActivityButtonValues.ACTIVITY_BUTTON_PADDING_TOP,
                              bottom: ActivityButtonValues.ACTIVITY_BUTTON_PADDING_BOTTOM),
                          child: Center(
                              child: RaisedButton(
                                child: Text(
                                    ActivityButtonValues.getActivityButtonString(pageId.data),
                                    style: TextStyle(fontSize: ActivityButtonValues.ACTIVITY_BUTTON_FONT_SIZE, fontWeight: FontWeight.w700)
                                ),
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ActivityButtonValues.ACTIVITY_BUTTON_CLIP_RADIUS))),
                                color: HomeScreenValues.getPageAccentColor(pageId.data),
                                splashColor: HomeScreenValues.getActivityButtonSplashColor(pageId.data),
                                onPressed: () => homeScreenBloc.activitiesSink.add(ActivityFactory.createActivity(activities.data, pageId.data)),
                              )
                          ),
                        ),
                        StreamBuilder<StatsGraphTimeFrame>(
                          stream: homeScreenBloc.timeFrame,
                          initialData: homeScreenBloc.initialTimeFrame,
                          builder: (context, graphTimeFrame) {
                            return GestureDetector(
                              onTapUp: (tapDetails) => homeScreenBloc.timeFrameSink.add(StatsGraphTimeFrameHelper.getNextTimeFrame(graphTimeFrame.data)),
                              child: Padding(
                                padding: EdgeInsets.only(top: StatsGraphValues.PADDING_TOP),
                                child: StatsGraph(
                                    activities.data,
                                    pageId: pageId.data,
                                    timeFrame: graphTimeFrame.data,
                                    graphMarkupColor: ColorHelper.darken(HomeScreenValues.getBackgroundColor(pageId.data),
                                        StatsGraphValues.MARKUP_COLOR_DARKEN_VALUE),
                                    graphLineColor: HomeScreenValues.getGraphLineColor(pageId.data),
                                    graphCircleColor: HomeScreenValues.getGraphCircleColor(pageId.data)
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              )
          );
        },
    );
  }
}

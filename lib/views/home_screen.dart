import 'package:flutter/material.dart';
import 'package:useful_app/blocs/providers.dart';
import 'package:useful_app/customWidgets/breathing_image.dart';
import 'package:useful_app/customWidgets/custom_fab.dart';
import 'package:useful_app/customWidgets/stats_graph.dart';
import 'package:useful_app/models/activity.dart';
import 'package:useful_app/models/session_data_model.dart';
import 'package:useful_app/util/color_helper.dart';
import 'package:useful_app/util/widget_values.dart';
import 'package:useful_app/views/activities_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "HomeScreen";

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    final homeScreenBloc = Providers.getHomeScreenBloc(context);
    return StreamBuilder<int>(
        stream: homeScreenBloc.pageId,
        initialData: homeScreenBloc.initialPageId,
        builder: (context, pageId) {
          return Scaffold(
              floatingActionButton: CustomFloatingActionButton(() => homeScreenBloc.pageIdSink.add(pageId.data + 1), pageId.data),
              body: Container(
                padding: EdgeInsets.all(HomeScreenValues.screenPadding),
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
                            size: BreathingImageValues.mainImgSize
                        ),
                        StreamBuilder<String>(
                          stream: homeScreenBloc.getLvlStream(pageId.data),
                          initialData: homeScreenBloc.initialLvlHeaderText,
                          builder: (context, textLvlHeader) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(HomeScreenValues.lvlTitlePadding),
                                child: Text(
                                  textLvlHeader.data,
                                  style: TextStyle(fontSize: HomeScreenValues.lvlTitleFontSize),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ActivityButtonValues.activityButtonPaddingTop,
                              bottom: ActivityButtonValues.activityButtonPaddingBottom),
                          child: Center(
                              child: RaisedButton(
                                child: Text(
                                    ActivityButtonValues.getActivityButtonString(pageId.data, activities.data),
                                    style: TextStyle(fontSize: ActivityButtonValues.activityButtonFontSize, fontWeight: FontWeight.w700)
                                ),
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ActivityButtonValues.activityButtonClipRadius))),
                                color: HomeScreenValues.getPageAccentColor(pageId.data),
                                splashColor: HomeScreenValues.getActivityButtonSplashColor(pageId.data),
                                onPressed: () {
                                  bool hasActivitiesForPage = false;
                                  activities.data.forEach(
                                          (activity) => hasActivitiesForPage |= (activity.pageId == pageId.data && !activity.activityCompleted)
                                  );
                                  if (!hasActivitiesForPage) {
                                    homeScreenBloc.activitiesSink.add(ActivityFactory.addActivity(activities.data, pageId.data, Activity.easyDifficulty));
                                  } else {
                                    Navigator.of(context).pushNamed(ActivitiesScreen.tag);
                                  }
                                },
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
                                padding: EdgeInsets.only(top: StatsGraphValues.paddingTop),
                                child: StatsGraph(
                                    activities.data,
                                    pageId: pageId.data,
                                    timeFrame: graphTimeFrame.data,
                                    graphMarkupColor: ColorHelper.darken(HomeScreenValues.getBackgroundColor(pageId.data),
                                        StatsGraphValues.markupColorDarkenValue),
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

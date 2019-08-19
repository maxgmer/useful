import 'package:flutter/material.dart';
import 'package:useful_app/blocs/providers.dart';
import 'package:useful_app/util/widget_values.dart';

class ActivitiesScreen extends StatefulWidget {
  static const String tag = "ActivitiesScreen";

  @override
  State<StatefulWidget> createState() => new _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<StatefulWidget> {

  @override
  Widget build(BuildContext context) {
    final activitiesScreenBloc = Providers.getActivitiesScreenBloc(context);
    return StreamBuilder(
        stream: activitiesScreenBloc.activities,
        builder: (context, activities) {
          if (activities.hasData)
            return Scaffold(
              backgroundColor: ActivityListCardValues.getBackgroundColor(activitiesScreenBloc.sessionData.pageId),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: ActivityListCardValues.listPaddingTop,
                          left: ActivityListCardValues.listPaddingLeft,
                          right: ActivityListCardValues.listPaddingRight),
                      itemCount: activities.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: ActivityListCardValues.spaceBetweenListItems),
                          child: Card(
                            color: ActivityListCardValues.getDifficultyColor(activities.data[index].difficulty, lightenValue: 50),
                            elevation: ActivityListCardValues.taskCardElevation,
                            child: ListTile(
                              title: Text(activities.data[index].message,
                                  style: ActivityListCardValues.getCardDescriptionTextStyle(activities.data[index].difficulty)
                              ),
                              trailing: Text(
                                  ActivityListCardValues.getDifficultyText(activities.data[index].difficulty),
                                  style: ActivityListCardValues.getCardDifficultyTextStyle(activities.data[index].difficulty)
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  )
                ],
              ),
            );
          else
            return Container(
              color: Colors.white,
            );
        }
    );
  }
}

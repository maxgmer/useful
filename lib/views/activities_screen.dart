import 'package:flutter/material.dart';
import 'package:useful_app/blocs/Providers.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/util/WidgetValues.dart';

class ActivitiesScreen extends StatefulWidget {
  static const String TAG = "ActivitiesScreen";

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
                          top: ActivityListCardValues.LIST_PADDING_TOP,
                          left: ActivityListCardValues.LIST_PADDING_LEFT,
                          right: ActivityListCardValues.LIST_PADDING_RIGHT),
                      itemCount: activities.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(top: ActivityListCardValues.SPACE_BETWEEN_LIST_ITEMS),
                          child: Card(
                            color: ActivityListCardValues.getDifficultyColor(activities.data[index].difficulty, lightenValue: 50),
                            elevation: ActivityListCardValues.TASK_CARD_ELEVATION,
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

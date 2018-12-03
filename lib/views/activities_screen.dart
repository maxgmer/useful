import 'package:flutter/material.dart';
import 'package:useful_app/blocs/Providers.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/util/ColorHelper.dart';
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
                            color: ActivityListCardValues.getCardBackgroundColor(activities.data[index].difficulty),
                            elevation: 3.0,
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
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ActivityListCardValues.getBackgroundColor(activitiesScreenBloc.sessionData.pageId),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            spreadRadius: -1.0
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RaisedButton(
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                child: Text("Get easy task!"),
                                color: ActivityListCardValues.getCardBackgroundColor(Activity.EASY_DIFFICULTY),
                                onPressed: (){},
                              ),
                              RaisedButton(
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                child: Text("Get medium task!"),
                                color: ActivityListCardValues.getCardBackgroundColor(Activity.MEDIUM_DIFFICULTY),
                                onPressed: (){},
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RaisedButton(
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                child: Text("Get hard task!"),
                                color: ActivityListCardValues.getCardBackgroundColor(Activity.HARD_DIFFICULTY),
                                onPressed: (){},
                              ),
                              RaisedButton(
                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                child: Text("Get crazy task!"),
                                color: ActivityListCardValues.getCardBackgroundColor(Activity.CRAZY_DIFFICULTY),
                                onPressed: (){},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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

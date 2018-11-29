import 'package:flutter/material.dart';
import 'package:useful_app/blocs/Providers.dart';

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
              body: ListView.builder(
                itemCount: activities.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("Image"),
                    title: Text("Hello")
                  );
                }
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

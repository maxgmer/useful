import 'package:flutter/widgets.dart';
import 'package:useful_app/blocs/ActivitiesScreenBloc.dart';
import 'package:useful_app/blocs/BaseBloc.dart';
import 'package:useful_app/blocs/HomeScreenBloc.dart';

class Providers extends InheritedWidget {
  final HomeScreenBloc homeScreenBloc;
  final ActivitiesScreenBloc activitiesScreenBloc;
  static final BaseBloc _baseBloc = BaseBloc();

  Providers({
    Key key,
    Widget child
  }) :
        activitiesScreenBloc = ActivitiesScreenBloc(_baseBloc),
        homeScreenBloc = HomeScreenBloc(_baseBloc),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeScreenBloc getHomeScreenBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Providers) as Providers).homeScreenBloc;
  static ActivitiesScreenBloc getActivitiesScreenBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Providers) as Providers).activitiesScreenBloc;
}
import 'package:flutter/widgets.dart';
import 'package:useful_app/blocs/HomeScreenBloc.dart';

class HomeScreenProvider extends InheritedWidget {
  final HomeScreenBloc homeScreenBloc;

  HomeScreenProvider({
    Key key,
    Widget child
  }) :
        homeScreenBloc = HomeScreenBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeScreenBloc getBloc(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeScreenProvider) as HomeScreenProvider).homeScreenBloc;
}
import 'package:flutter/widgets.dart';
import 'package:useful_app/blocs/HomeScreenBloc.dart';

class HomeScreenProvider extends InheritedWidget {
  final HomeScreenBloc userDataBloc;

  HomeScreenProvider({
    Key key,
    HomeScreenBloc userDataBloc,
    Widget child
  }) :
        userDataBloc = userDataBloc ?? HomeScreenBloc(),
  super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomeScreenBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomeScreenProvider) as HomeScreenProvider).userDataBloc;
}
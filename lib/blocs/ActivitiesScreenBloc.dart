import 'package:rxdart/rxdart.dart';
import 'package:useful_app/blocs/BaseBloc.dart';
import 'package:useful_app/models/Activity.dart';

class ActivitiesScreenBloc {
  final BaseBloc baseBloc;

  final BehaviorSubject<List<Activity>> _activitiesController = BehaviorSubject<List<Activity>>();

  Stream<List<Activity>> get activities => _activitiesController.stream;

  ActivitiesScreenBloc(this.baseBloc) {
    _initActivitiesScreenWidgets();
  }

  void _initActivitiesScreenWidgets() {
    _activitiesController.add(baseBloc.sessionData.activities);
  }

  void dispose() {
    _activitiesController.close();
  }
}
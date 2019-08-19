import 'package:rxdart/rxdart.dart';
import 'package:useful_app/blocs/base_bloc.dart';
import 'package:useful_app/models/activity.dart';

class ActivitiesScreenBloc {
  final BaseBloc _baseBloc;

  final BehaviorSubject<List<Activity>> _activitiesController = BehaviorSubject<List<Activity>>();
  Stream<List<Activity>> get activities => _activitiesController.stream;

  final BehaviorSubject<int> _pageIdController = BehaviorSubject<int>();
  Stream<int> get pageId => _pageIdController.stream;

  ActivitiesScreenBloc(this._baseBloc) {
    _initActivitiesScreenWidgets();
  }

  get sessionData => _baseBloc.sessionData;
  get userData => _baseBloc.userData;

  void _initActivitiesScreenWidgets() {
    _activitiesController.add(_baseBloc.sessionData.activities);
    _pageIdController.add(_baseBloc.sessionData.pageId);
  }

  void dispose() {
    _activitiesController.close();
    _pageIdController.close();
  }
}
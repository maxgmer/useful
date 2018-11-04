import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/WidgetValues.dart';


class HomeScreenBloc {
  final int initialPageId = 0;
  final List<Activity> initialActivities = List<Activity>();
  final initialLvlHeaderText = "Health lvl: loading..";
  final initialTimeFrame = StatsGraphTimeFrame.WEEK;

  final SessionDataModel _sessionData = SessionDataModel();
  final UserDataModel _userData = UserDataModel();


  HomeScreenBloc() {
    _initHomeScreenWidgets();
    timeFrame.listen((statsGraphTimeFrame) => _sessionData.graphTimeFrame = statsGraphTimeFrame);
    activities.listen((activities) => _sessionData.activities = activities);
  }

  //read only for view, so we expose only Streams from these controllers
  final BehaviorSubject<int> _healthLvlController = BehaviorSubject<int>();
  final BehaviorSubject<int> _wealthLvlController = BehaviorSubject<int>();
  final BehaviorSubject<int> _loveLvlController = BehaviorSubject<int>();
  final BehaviorSubject<int> _happinessLvlController = BehaviorSubject<int>();

  Stream<String> get healthLvl => _formattedHealthLvlStream();
  Stream<String> get wealthLvl => _formattedWealthLvlStream();
  Stream<String> get loveLvl => _formattedLoveLvlStream();
  Stream<String> get happinessLvl => _formattedHappinessLvlStream();


  final BehaviorSubject<int> _pageIdController = BehaviorSubject<int>();

  Stream<int> get pageId => _wrappedPageIdStream();
  Sink<int> get pageIdSink => _pageIdController.sink;


  final BehaviorSubject<StatsGraphTimeFrame> _timeFrameController = BehaviorSubject<StatsGraphTimeFrame>();

  Stream<StatsGraphTimeFrame> get timeFrame => _timeFrameController.stream;
  Sink<StatsGraphTimeFrame> get timeFrameSink => _timeFrameController.sink;


  final BehaviorSubject<List<Activity>> _activitiesController = BehaviorSubject<List<Activity>>();

  Stream<List<Activity>> get activities => _activitiesController.stream;
  Sink<List<Activity>> get activitiesSink => _activitiesController.sink;

  Stream<String> getLvlStream(int currentPageId) {
    switch(currentPageId) {
      case 0: return healthLvl;
      case 1: return wealthLvl;
      case 2: return loveLvl;
      case 3: return happinessLvl;
    }
    return healthLvl;
  }

  void dispose() {
    _healthLvlController.close();
    _wealthLvlController.close();
    _loveLvlController.close();
    _happinessLvlController.close();
    _pageIdController.close();
    _timeFrameController.close();
    _activitiesController.close();
  }

  /*
  Sends initial values to streams.
  I don't specify initialData in constructors
  int StreamBuilders as I think it is also a part of
  business logic.
  */
  void _initHomeScreenWidgets() {
    _healthLvlController.add(_userData.healthLvl);
    _wealthLvlController.add(_userData.wealthLvl);
    _loveLvlController.add(_userData.loveLvl);
    _happinessLvlController.add(_userData.happinessLvl);
    timeFrameSink.add(_sessionData.graphTimeFrame);
    activitiesSink.add(_sessionData.activities);
    pageIdSink.add(_sessionData.pageId);
  }

  //Does not let user change to non-existent page

  Stream<String> _formattedHealthLvlStream() {
    return _healthLvlController.stream.map((lvlNum) => "Health lvl: $lvlNum");
  }
  Stream<String> _formattedWealthLvlStream() {
    return _wealthLvlController.stream.map((lvlNum) => "Wealth lvl: $lvlNum");
  }
  Stream<String> _formattedLoveLvlStream() {
    return _loveLvlController.stream.map((lvlNum) => "Love lvl: $lvlNum");
  }
  Stream<String> _formattedHappinessLvlStream() {
    return _happinessLvlController.stream.map((lvlNum) => "Happiness lvl: $lvlNum");
  }

  Stream<int> _wrappedPageIdStream() {
    return _pageIdController.stream.map((pageId) {
      if (pageId > HomeScreenValues.MAX_PAGE_ID) {
        pageId = 0;
        pageIdSink.add(pageId);
      }
      if (pageId < 0) {
        pageId = HomeScreenValues.MAX_PAGE_ID;
        pageIdSink.add(pageId);
      }
      _sessionData.pageId = pageId;

      return pageId;
    });
  }
}
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/WidgetValues.dart';


class HomeScreenBloc {
  final SessionDataModel _sessionData = new SessionDataModel();
  final UserDataModel _userData = new UserDataModel();

  HomeScreenBloc() {
    _initHomeScreenWidgetsWithInitialValues();
    graph.listen((statsGraphTimeFrame) => _sessionData.graphTimeFrame = statsGraphTimeFrame);
    activities.listen((activities) => _sessionData.activities = activities);
  }

  //read only for view, so we expose only Streams from these controllers
  final BehaviorSubject<int> _healthLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _wealthLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _loveLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _happinessLvlController = new BehaviorSubject<int>();

  Stream<String> get healthLvl => _formattedHealthLvlStream();
  Stream<String> get wealthLvl => _formattedWealthLvlStream();
  Stream<String> get loveLvl => _formattedLoveLvlStream();
  Stream<String> get happinessLvl => _formattedHappinessLvlStream();


  final BehaviorSubject<int> _pageIdController = new BehaviorSubject<int>();

  Stream<int> get pageId => _wrappedPageIdStream();
  Sink<int> get pageIdSink => _pageIdController.sink;


  final BehaviorSubject<StatsGraphTimeFrame> _statsGraphTimeFrameController = new BehaviorSubject<StatsGraphTimeFrame>();

  Stream<StatsGraphTimeFrame> get graph => _statsGraphTimeFrameController.stream;
  Sink<StatsGraphTimeFrame> get graphSink => _statsGraphTimeFrameController.sink;


  final BehaviorSubject<List<Activity>> _activitiesController = new BehaviorSubject<List<Activity>>();

  Stream<List<Activity>> get activities => _activitiesController.stream;
  Sink<List<Activity>> get activitiesSink => _activitiesController.sink;

  Stream<String> getLvlStream(int currentPageId) {
    switch(currentPageId) {
      case 0: return healthLvl;
      case 1: return wealthLvl;
      case 2: return loveLvl;
      case 3: return happinessLvl;
    }
    throw "Unknown page ID";
  }

  String getImproveButtonString(int currentPageId) {
    switch(currentPageId) {
      case 0: return "Improve health!";
      case 1: return "Become wealthy!";
      case 2: return "Express love!";
      case 3: return "Find happiness!";
    }
    throw "Unknown page ID";
  }

  void dispose() {
    _healthLvlController.close();
    _wealthLvlController.close();
    _loveLvlController.close();
    _happinessLvlController.close();
    _pageIdController.close();
    _statsGraphTimeFrameController.close();
    _activitiesController.close();
  }

  /*
  Sends initial values to streams.
  I don't specify initialData in constructors
  int StreamBuilders as I think it is also a part of
  business logic.
  */
  void _initHomeScreenWidgetsWithInitialValues() {
    _healthLvlController.add(_userData.healthLvl);
    _wealthLvlController.add(_userData.wealthLvl);
    _loveLvlController.add(_userData.loveLvl);
    _happinessLvlController.add(_userData.happinessLvl);
    pageIdSink.add(_sessionData.pageId);
    graphSink.add(_sessionData.graphTimeFrame);
    activitiesSink.add(_sessionData.activities);
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
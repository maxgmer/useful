import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/views/home_screen.dart';

class HomeScreenBloc {
  final SessionDataModel _sessionData = new SessionDataModel();
  final UserDataModel _userData = new UserDataModel();

  HomeScreenBloc() {
    _pageIdController.stream.listen((pageId) => _sessionData.pageId = pageId);
  }

  //read only for view, so we expose only Streams from these controllers
  final BehaviorSubject<int> _healthLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _wealthLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _loveLvlController = new BehaviorSubject<int>();
  final BehaviorSubject<int> _happinessLvlController = new BehaviorSubject<int>();

  Stream<int> get healthLvl => _healthLvlController.stream;
  Stream<int> get wealthLvl => _wealthLvlController.stream;
  Stream<int> get loveLvl => _loveLvlController.stream;
  Stream<int> get happinessLvl => _happinessLvlController.stream;



  final BehaviorSubject<int> _pageIdController = new _PageBehaviorSubject();

  Stream<int> get pageId => _pageIdController.stream;
  Sink<int> get pageIdSink => _pageIdController.sink;



  void dispose() {
    _healthLvlController.close();
    _wealthLvlController.close();
    _loveLvlController.close();
    _happinessLvlController.close();

    _pageIdController.close();
  }
}

class HomeScreenValues {
  static const int _MAX_PAGE_ID = 3;

  static const double SCREEN_PADDING = 50.0;
  static const double mainImageDims = 144.0;

  static getBackgroundColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(184, 240, 119, 1.0);//Color.fromRGBO(138, 194, 73, 1.0);
      case 1: return Color.fromRGBO(1, 1, 0, 1.0);
      case 2: return Color.fromRGBO(1, 0, 1, 1.0);
      case 3: return Color.fromRGBO(1, 0, 0, 1.0);
    }
  }
}

class _PageBehaviorSubject extends BehaviorSubject<int> {


  @override
  void onAdd(int event) {
    if (event > HomeScreenValues._MAX_PAGE_ID) {
      event = 0;
    }
    if (event < 0) {
      event = HomeScreenValues._MAX_PAGE_ID;
    }
    print("${HomeScreen.TAG} current page is $event");

    super.onAdd(event);
  }
}
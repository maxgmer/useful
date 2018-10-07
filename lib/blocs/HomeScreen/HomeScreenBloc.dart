import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';

class HomeScreenBloc {
  final SessionDataModel _sessionData = new SessionDataModel();
  final UserDataModel _userData = new UserDataModel();

  HomeScreenBloc() {
    _initHomeScreenWidgetsWithInitialValues();
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

  Stream<String> getLvlStreamForPage(int currentPageId) {
    switch(currentPageId) {
      case 0: return healthLvl;
      case 1: return wealthLvl;
      case 2: return loveLvl;
      case 3: return happinessLvl;
    }
  }

  void dispose() {
    _healthLvlController.close();
    _wealthLvlController.close();
    _loveLvlController.close();
    _happinessLvlController.close();
    _pageIdController.close();
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
    });
  }
}


//A convenience class for storing constants.
class HomeScreenValues {
  static const int MAX_PAGE_ID = 3;

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
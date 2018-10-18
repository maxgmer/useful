import 'dart:async';
import 'dart:math';
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


  final BehaviorSubject<StatsGraphTimeFrame> _statsGraphTimeFrameController = new BehaviorSubject<StatsGraphTimeFrame>();

  Stream<StatsGraphTimeFrame> get graph => _statsGraphTimeFrameController.stream;
  Sink<StatsGraphTimeFrame> get graphSink => _statsGraphTimeFrameController.sink;

  Stream<String> getLvlStreamForPage(int currentPageId) {
    switch(currentPageId) {
      case 0: return healthLvl;
      case 1: return wealthLvl;
      case 2: return loveLvl;
      case 3: return happinessLvl;
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
//////////////////////////////////////////////////////////
//                                                      //
//   Classes below are for storing constants            //
//   like padding, colors etc.                          //
//                                                      //
//////////////////////////////////////////////////////////
class HomeScreenValues {
  static const int MAX_PAGE_ID = 3;

  static const double SCREEN_PADDING = 30.0;

  static const double LVL_TITLE_PADDING = 15.0;

  static const double PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double INSIDE_PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double PAGE_DETAILS_ROW_IMG_DIMS = 48.0;

  static const double LVL_TITLE_FONT_SIZE = 25.0;


  static getBackgroundColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(184, 240, 119, 1.0);
      case 1: return Color.fromRGBO(254, 248, 197, 1.0);
      case 2: return Color.fromRGBO(255, 201, 182, 1.0);
      case 3: return Color.fromRGBO(194, 250, 248, 1.0);
    }
  }

  static getFABColor(double value) => Color.lerp(getFABOnPressedColor(), Color.fromRGBO(248, 169, 54, 1.0), value); //smoothly interpolates from pressed to main
  static getFABOnPressedColor() => Color.fromRGBO(174, 95, 0, 1.0);
}



class CustomFABValues {
  static const int ANIMATION_DURATION = 200;

  static const double MIN_PADDING_RIGHT = 5.0;
  static const double MIN_PADDING_BOTTOM = 10.0;
  static const double INTERPOLATABLE_PADDING_RIGHT = 5.0;
  static const double INTERPOLATABLE_PADDING_BOTTOM = 15.0;
  static const double SIZE = 25.0;
  static const int MAX_ELEVATION = 10;

  static const double _MAX_CORNER_CLIP_SECONDARY = 40.0;
  static const double _MAX_CORNER_CLIP_MAIN = 60.0;

  static const int _GUARANTEED_CLIP_MAIN = 5;
  static const int _GUARANTEED_CLIP_SECONDARY = 2;

  static double calcRandomClipMain() => Random().nextDouble() * _MAX_CORNER_CLIP_MAIN + _GUARANTEED_CLIP_MAIN;
  static double calcRandomClipSecondary() => Random().nextDouble() * _MAX_CORNER_CLIP_SECONDARY + _GUARANTEED_CLIP_SECONDARY;
}



class BreathingImageValues {
  static const int ANIMATION_DURATION = 4000;

  static const double MAIN_IMG_SIZE = 120.0;
  static const int FULL_LUNGS_SIZE_ADDITION = 10;

  static String getImagePath(int pageId) {
    switch(pageId) {
      case 0: return "assets/images/healthPageSymbol.png";
      case 1: return "assets/images/wealthPageSymbol.png";
      case 2: return "assets/images/lovePageSymbol.png";
      case 3: return "assets/images/happinessPageSymbol.png";
    }
  }
}


class StatsGraphValues {
  static const double PADDING_TOP = 90.0;

  static const int MARKUP_COLOR_DARKEN_VALUE = 50;

  static const double SIZE = 200.0;

  static const double FONT_SIZE_VERTICAL_MARKUP_TEXT = 17.0;
  static const double FONT_SIZE_HORIZONTAL_MARKUP_TEXT = 16.0;

  static const double SPACE_FOR_NUMBERS_SIZE = 35.0;
}

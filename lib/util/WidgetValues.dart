import 'dart:math';

import 'package:flutter/material.dart';

/*
  Widget values, which are not connected to business logic
 */
class HomeScreenValues {
  static const int MAX_PAGE_ID = 3;

  static const double SCREEN_PADDING = 30.0;

  static const double LVL_TITLE_PADDING = 15.0;
  static const double IMPROVE_BUTTON_PADDING_TOP = 70.0;

  static const double PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double INSIDE_PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double PAGE_DETAILS_ROW_IMG_DIMS = 48.0;

  static const double LVL_TITLE_FONT_SIZE = 25.0;
  static const double IMPROVE_BUTTON_FONT_SIZE = 24.0;

  static const double IMPROVE_BUTTON_CLIP_RADIUS = 10.0;

  static Color getBackgroundColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(184, 240, 119, 1.0);
      case 1: return Color.fromRGBO(254, 248, 197, 1.0);
      case 2: return Color.fromRGBO(255, 201, 182, 1.0);
      case 3: return Color.fromRGBO(194, 250, 248, 1.0);
    }
    throw "Unknown page ID";
  }

  static Color getImproveButtonColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(235, 254, 169, 1.0);
      case 1: return Color.fromRGBO(222, 217, 169, 1.0);
      case 2: return Color.fromRGBO(255, 182, 169, 1.0);
      case 3: return Color.fromRGBO(179, 225, 255, 1.0);
    }
    throw "Unknown page ID";
  }

  static Color getImproveButtonSplashColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(132, 188, 74, 1.0);
      case 1: return Colors.brown;
      case 2: return Colors.pinkAccent;
      case 3: return Colors.cyan;
    }
    throw "Unknown page ID";
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
  static const double SIZE = 30.0;
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
    throw "Unknown page ID";
  }
}


class StatsGraphValues {
  static const double PADDING_TOP = 10.0;

  static const int MARKUP_COLOR_DARKEN_VALUE = 50;

  static const double SIZE = 200.0;

  static const double FONT_SIZE_VERTICAL_MARKUP_TEXT = 17.0;
  static const double FONT_SIZE_HORIZONTAL_MARKUP_TEXT = 16.0;

  static const double SPACE_FOR_NUMBERS_SIZE = 35.0;
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/ColorHelper.dart';

/*
  Widget values, which are not connected to business logic
 */
class HomeScreenValues {
  static const int MAX_PAGE_ID = 3;

  static const double SCREEN_PADDING = 30.0;

  static const double LVL_TITLE_PADDING = 15.0;

  static const double PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double INSIDE_PAGE_DETAILS_ROW_PADDING = 10.0;
  static const double PAGE_DETAILS_ROW_IMG_DIMS = 48.0;

  static const double LVL_TITLE_FONT_SIZE = 25.0;

  static Color getBackgroundColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(184, 240, 119, 1.0);
      case 1: return Color.fromRGBO(254, 248, 197, 1.0);
      case 2: return Color.fromRGBO(255, 201, 182, 1.0);
      case 3: return Color.fromRGBO(194, 250, 248, 1.0);
    }
    throw "Unknown page ID";
  }

  static Color getPageAccentColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(235, 254, 169, 1.0);
      case 1: return Color.fromRGBO(222, 217, 169, 1.0);
      case 2: return Color.fromRGBO(255, 182, 169, 1.0);
      case 3: return Color.fromRGBO(179, 225, 255, 1.0);
    }
    throw "Unknown page ID";
  }

  static Color getGraphLineColor(int pageId) {
    switch(pageId) {
      case 0: return getPageAccentColor(pageId);
      case 1: return ColorHelper.darken(getPageAccentColor(pageId), 30);
      case 2: return Color.fromRGBO(180, 130, 130, 1.0);
      case 3: return ColorHelper.addGreen(ColorHelper.darken(getPageAccentColor(pageId), 100), 50);
    }
    throw "Unknown page ID";
  }

  static getGraphCircleColor(int pageId) {
    switch(pageId) {
      case 0: return ColorHelper.darken(getGraphLineColor(pageId), 50);
      case 1: return ColorHelper.darken(getGraphLineColor(pageId), 60);
      case 2: return ColorHelper.darken(getGraphLineColor(pageId), 60);
      case 3: return ColorHelper.darken(getGraphLineColor(pageId), 60);
    }
    throw "Unknown page ID";
  }

  static Color getActivityButtonSplashColor(int pageId) {
    switch(pageId) {
      case 0: return Color.fromRGBO(132, 188, 74, 1.0);
      case 1: return Colors.brown;
      case 2: return Colors.pinkAccent;
      case 3: return Colors.cyan;
    }
    throw "Unknown page ID";
  }

  static getFABColor(double value, int pageId) => getBackgroundColor((pageId + 1) % (MAX_PAGE_ID + 1));
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

  static const double FONT_SIZE_HEADLINE = 12.0;
  static const double FONT_SIZE_VERTICAL_MARKUP_TEXT = 17.0;
  static const double FONT_SIZE_HORIZONTAL_MARKUP_TEXT = 16.0;

  static const double SPACE_FOR_NUMBERS_SIZE = 35.0;

  static const double MARKUP_STROKE_WIDTH = 1.0;

  static const double GRAPH_LINE_STROKE_WIDTH = 3.0;

  static const double GRAPH_CIRCLE_RADIUS = 3.0;

  static String getGraphHeadlineString(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK: return "Activities completed during the current week";
      case StatsGraphTimeFrame.MONTH: return "Activities completed during the current month";
      case StatsGraphTimeFrame.YEAR: return "Activities completed during the current year";
    }
    throw "Unknown page ID";
  }
}

class ActivityButtonValues {
  static const double ACTIVITY_BUTTON_PADDING_TOP = 70.0;
  static const double ACTIVITY_BUTTON_PADDING_BOTTOM = 20.0;
  static const double ACTIVITY_BUTTON_FONT_SIZE = 24.0;
  static const double ACTIVITY_BUTTON_CLIP_RADIUS = 10.0;

  static String getActivityButtonString(int currentPageId, List<Activity> activities) {
    bool hasActivitiesForPage = false;
    activities.forEach(
            (activity) => hasActivitiesForPage |= (activity.pageId == currentPageId && !activity.activityCompleted)
    );
    switch(currentPageId) {
      case 0:
        return hasActivitiesForPage ? "View health tasks" : "Improve health!";
      case 1:
        return hasActivitiesForPage ? "View wealth tasks" : "Become wealthy!";
      case 2:
        return hasActivitiesForPage ? "View love tasks" : "Express love!";
      case 3:
        return hasActivitiesForPage ? "View happiness tasks" : "Find happiness!";
    }
    throw "Unknown page ID";
  }
}

class ActivityListCardValues {
  static const double LIST_PADDING_TOP = 50.0;
  static const double LIST_PADDING_RIGHT = 20.0;
  static const double LIST_PADDING_LEFT = 20.0;
  static const double SPACE_BETWEEN_LIST_ITEMS = 8.0;

  static Color getCardBackgroundColor(int difficulty) {
    switch(difficulty) {
      case Activity.EASY_DIFFICULTY: return Color.fromRGBO(104, 159, 56, 1.0);
      case Activity.MEDIUM_DIFFICULTY: return Color.fromRGBO(255, 167, 38, 1.0);
      case Activity.HARD_DIFFICULTY: return Color.fromRGBO(255, 122, 77, 1.0);
      case Activity.CRAZY_DIFFICULTY: return Color.fromRGBO(33, 33, 33, 1.0);
    }
    throw "Such difficulty color does not exist";
  }

  static String getDifficultyText(int difficulty) {
    switch(difficulty) {
      case Activity.EASY_DIFFICULTY: return "Difficulty:\nEasy";
      case Activity.MEDIUM_DIFFICULTY: return "Difficulty:\nMedium";
      case Activity.HARD_DIFFICULTY: return "Difficulty:\nHard";
      case Activity.CRAZY_DIFFICULTY: return "Difficulty:\nCrazy";
    }
    throw "Such difficulty text does not exist";
  }

  static Color getBackgroundColor(pageId) {
    return HomeScreenValues.getBackgroundColor(pageId);
  }

  static TextStyle getCardDescriptionTextStyle(int difficulty) {
    if (difficulty == Activity.CRAZY_DIFFICULTY) {
      return TextStyle(color: Colors.grey);
    }
    return TextStyle(color: Colors.black);
  }

  static TextStyle getCardDifficultyTextStyle(int difficulty) {
    if (difficulty == Activity.CRAZY_DIFFICULTY) {
      return TextStyle(color: Colors.grey);
    }
    return TextStyle(color: Colors.black);
  }
}

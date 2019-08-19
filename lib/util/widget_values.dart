import 'dart:math';

import 'package:flutter/material.dart';
import 'package:useful_app/models/activity.dart';
import 'package:useful_app/models/session_data_model.dart';
import 'package:useful_app/util/color_helper.dart';

class HomeScreenValues {
  static const int maxPageId = 3;

  static const double screenPadding = 30.0;

  static const double lvlTitlePadding = 15.0;

  static const double pageDetailsRowPadding = 10.0;
  static const double insidePageDetailsRowPadding = 10.0;
  static const double pageDetailsRowImgDims = 48.0;

  static const double lvlTitleFontSize = 25.0;

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

  static getFABColor(double value, int pageId) => getBackgroundColor((pageId + 1) % (maxPageId + 1));
}



class CustomFABValues {
  static const int animationDuration = 200;

  static const double minPaddingRight = 5.0;
  static const double minPaddingBottom = 10.0;
  static const double interpolatablePaddingRight = 5.0;
  static const double interpolatablePaddingBottom = 15.0;
  static const double size = 30.0;
  static const int maxElevation = 10;

  static const double _maxCornerClipSecondary = 40.0;
  static const double _maxCornerClipMain = 60.0;

  static const int _guaranteedClipMain = 5;
  static const int _guaranteedClipSecondary = 2;

  static double calcRandomClipMain() => Random().nextDouble() * _maxCornerClipMain + _guaranteedClipMain;
  static double calcRandomClipSecondary() => Random().nextDouble() * _maxCornerClipSecondary + _guaranteedClipSecondary;
}



class BreathingImageValues {
  static const int animationDuration = 4000;

  static const double mainImgSize = 120.0;
  static const int fullLungsSizeAddition = 10;

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
  static const double paddingTop = 10.0;

  static const int markupColorDarkenValue = 50;

  static const double size = 200.0;

  static const double fontSizeHeadline = 12.0;
  static const double fontSizeVerticalMarkupText = 17.0;
  static const double fontSizeHorizontalMarkupText = 16.0;

  static const double spaceForNumbersSize = 35.0;

  static const double markupStrokeWidth = 1.0;

  static const double graphLineStrokeWidth = 3.0;

  static const double graphCircleRadius = 3.0;

  static String getGraphHeadlineString(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.week: return "Activities completed during the current week";
      case StatsGraphTimeFrame.month: return "Activities completed during the current month";
      case StatsGraphTimeFrame.year: return "Activities completed during the current year";
    }
    throw "Unknown page ID";
  }
}

class ActivityButtonValues {
  static const double activityButtonPaddingTop = 70.0;
  static const double activityButtonPaddingBottom = 20.0;
  static const double activityButtonFontSize = 24.0;
  static const double activityButtonClipRadius = 10.0;

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
  static const double listPaddingTop = 50.0;
  static const double listPaddingRight = 20.0;
  static const double listPaddingLeft = 20.0;
  static const double spaceBetweenListItems = 8.0;

  static const double footerShadowRadius = 3.0;
  static const double footerSpreadRadius = -1.0;

  static const double footerPaddingTop = 10.0;
  static const double footerPaddingBottom = 5.0;

  static const double footerButtonCornerClip = 10.0;

  static const double taskCardElevation = 3.0;

  static Color getDifficultyColor(int difficulty, {int lightenValue}) {
    Color difficultyColor;
    switch(difficulty) {
      case Activity.easyDifficulty:
        difficultyColor = Color.fromRGBO(104, 159, 56, 1.0);
        break;
      case Activity.mediumDifficulty:
        difficultyColor = Color.fromRGBO(255, 167, 38, 1.0);
        break;
      case Activity.hardDifficulty:
        difficultyColor = Color.fromRGBO(255, 122, 77, 1.0);
        break;
      case Activity.crazyDifficulty:
        difficultyColor = Color.fromRGBO(33, 33, 33, 1.0);
        break;
    }
    if (difficultyColor == null)
      throw "Such difficulty color does not exist";
    if (lightenValue != null && difficulty != Activity.crazyDifficulty)
      return ColorHelper.lighten(difficultyColor, lightenValue);
    return difficultyColor;
  }

  static String getDifficultyText(int difficulty) {
    switch(difficulty) {
      case Activity.easyDifficulty: return "Difficulty:\nEasy";
      case Activity.mediumDifficulty: return "Difficulty:\nMedium";
      case Activity.hardDifficulty: return "Difficulty:\nHard";
      case Activity.crazyDifficulty: return "Difficulty:\nCrazy";
    }
    throw "Such difficulty text does not exist";
  }

  static Color getBackgroundColor(pageId) {
    return HomeScreenValues.getBackgroundColor(pageId);
  }

  static TextStyle getCardDescriptionTextStyle(int difficulty) {
    if (difficulty == Activity.crazyDifficulty) {
      return TextStyle(color: Colors.grey);
    }
    return TextStyle(color: Colors.black);
  }

  static TextStyle getCardDifficultyTextStyle(int difficulty) {
    if (difficulty == Activity.crazyDifficulty) {
      return TextStyle(color: Colors.grey);
    }
    return TextStyle(color: Colors.black);
  }

  static String getTaskButtonText(int difficulty) {
    switch (difficulty) {
      case Activity.easyDifficulty: return "Get easy task!";
      case Activity.mediumDifficulty: return "Get medium task!";
      case Activity.hardDifficulty: return "Get hard task!";
      case Activity.crazyDifficulty: return "Get crazy task!";
    }
    throw "Such difficulty does not exist";
  }

  static getFooterButtonTextStyle(int difficulty) {
    if (difficulty == Activity.crazyDifficulty) {
      return TextStyle(color: Colors.grey);
    }
    return TextStyle(color: Colors.black);
  }
}

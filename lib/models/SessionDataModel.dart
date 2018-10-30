import 'package:useful_app/models/Activity.dart';

class SessionDataModel {
  SessionDataModel();

  List<Activity> _activities = List<Activity>();
  List<Activity> get activities => _activities;
  set activities(List<Activity> activities) => _activities = activities;

  int _pageId = 0;
  int get pageId => _pageId;
  set pageId(pageId) => _pageId = pageId;

  StatsGraphTimeFrame _graphTimeFrame = StatsGraphTimeFrame.WEEK;
  StatsGraphTimeFrame get graphTimeFrame => _graphTimeFrame;
  set graphTimeFrame(graphTimeFrame) => _graphTimeFrame;
}


//need to move these somewhere else (IDE does not support that atm, too lazy to do that manually xD)
class StatsGraphTimeFrameHelper {
  static List<String> getStrings(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK: return ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
      case StatsGraphTimeFrame.MONTH: return ["07", "14", "21", "28"];
      case StatsGraphTimeFrame.YEAR: return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
    }
    throw "Such timeframe does not exist!";
  }

  static DateTime getTimeFrameBeginning(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK:
        DateTime beginningOfTheWeek = DateTime.now();
        beginningOfTheWeek = beginningOfTheWeek.toLocal();
        //reset time to 00:00
        beginningOfTheWeek = beginningOfTheWeek.subtract(
            Duration(hours: beginningOfTheWeek.hour, minutes: beginningOfTheWeek.minute, seconds: beginningOfTheWeek.second));
        //reset weekday to monday
        beginningOfTheWeek = beginningOfTheWeek.subtract(
            Duration(days: beginningOfTheWeek.weekday - 1));
        return beginningOfTheWeek;
      case StatsGraphTimeFrame.MONTH:
        DateTime beginningOfTheMonth = DateTime.now();
        beginningOfTheMonth = beginningOfTheMonth.toLocal();
        //reset time to 00:00
        beginningOfTheMonth = beginningOfTheMonth.subtract(
            Duration(hours: beginningOfTheMonth.hour, minutes: beginningOfTheMonth.minute, seconds: beginningOfTheMonth.second));
        //reset day to first of the month
        beginningOfTheMonth = beginningOfTheMonth.subtract(
            Duration(days: beginningOfTheMonth.day - 1));
        return beginningOfTheMonth;
      case StatsGraphTimeFrame.YEAR:
        DateTime beginningOfTheYear = DateTime.now();
        beginningOfTheYear = beginningOfTheYear.toLocal();
        //reset time to 00:00
        beginningOfTheYear = beginningOfTheYear.subtract(
            Duration(hours: beginningOfTheYear.hour, minutes: beginningOfTheYear.minute, seconds: beginningOfTheYear.second));
        //reset month to january
        while (beginningOfTheYear.month != 1)
          beginningOfTheYear = beginningOfTheYear.subtract(
              Duration(days: 30));
        //reset day to first of the month
        beginningOfTheYear = beginningOfTheYear.subtract(
            Duration(days: beginningOfTheYear.day - 1));
        return beginningOfTheYear;
    }
    throw "Such timeframe does not exist!";
  }

  //e.g for year timeframe returns number of activities in the best month (month with highest number of completed activities)
  static int getBestActivitiesNumber(StatsGraphTimeFrame timeFrame,
      List<Activity> currentTimeFrameActivities, DateTime beginningOfTheTimeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK:
        int maxActivitiesInSegment = 0;
        while (true) {
          int activitiesInSegment = 0;
          for (Activity activity in currentTimeFrameActivities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + Duration.millisecondsPerDay)))
              activitiesInSegment++;
          }
          if (activitiesInSegment > maxActivitiesInSegment)
            maxActivitiesInSegment = activitiesInSegment;

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));

          if (beginningOfTheTimeFrame.weekday == 7) return maxActivitiesInSegment;
        }
        break;
      case StatsGraphTimeFrame.MONTH:
        int maxActivitiesInSegment = 0;
        //when we specify 0 for day it gives us last day of the previous month
        var lastDayOfMonth = DateTime(beginningOfTheTimeFrame.year, beginningOfTheTimeFrame.month + 1, 0);
        while (true) {
          int activitiesInSegment = 0;
          for (Activity activity in currentTimeFrameActivities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + Duration.millisecondsPerDay)))
              activitiesInSegment++;
          }
          if (activitiesInSegment > maxActivitiesInSegment)
            maxActivitiesInSegment = activitiesInSegment;

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));

          if (beginningOfTheTimeFrame.day == lastDayOfMonth.day) return maxActivitiesInSegment;
        }
        break;
      case StatsGraphTimeFrame.YEAR:
        int maxActivitiesInSegment = 0;
        while (true) {
          //when we specify 0 for day it gives us last day of the previous month
          var lastDayOfMonth = beginningOfTheTimeFrame.month == 12 ?
          DateTime(beginningOfTheTimeFrame.year + 1, 1, 0) :
          DateTime(beginningOfTheTimeFrame.year, beginningOfTheTimeFrame.month + 1, 0);

          int activitiesInSegment = 0;
          for (Activity activity in currentTimeFrameActivities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + (Duration.millisecondsPerDay * lastDayOfMonth.day))))
              activitiesInSegment++;
          }
          if (activitiesInSegment > maxActivitiesInSegment)
            maxActivitiesInSegment = activitiesInSegment;

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));

          if (beginningOfTheTimeFrame.month == 12) return maxActivitiesInSegment;
        }
    }
    throw "Such timeframe does not exist";
  }
}

enum StatsGraphTimeFrame{
  WEEK, MONTH, YEAR
}
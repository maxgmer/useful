import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/util/DateHelper.dart';

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
  static StatsGraphTimeFrame getNextTimeFrame(StatsGraphTimeFrame currentTimeFrame) {
    List<StatsGraphTimeFrame> timeFrames = StatsGraphTimeFrame.values;
    return timeFrames[(currentTimeFrame.index + 1) % timeFrames.length];
  }

  static List<String> getStrings(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK: return ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
      case StatsGraphTimeFrame.MONTH: return ["01", "07", "14", "21", "28"];
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
        bool lastCycleIteration = false;
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


          if (lastCycleIteration) return maxActivitiesInSegment;
          if (beginningOfTheTimeFrame.weekday == 7) lastCycleIteration = true;
        }
        break;
      case StatsGraphTimeFrame.MONTH:
        int maxActivitiesInSegment = 0;
        int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);
        bool lastCycleIteration = false;
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


          if (lastCycleIteration) return maxActivitiesInSegment;
          if (beginningOfTheTimeFrame.day == daysInMonth) lastCycleIteration = true;
        }
        break;
      case StatsGraphTimeFrame.YEAR:
        int maxActivitiesInSegment = 0;
        bool lastCycleIteration = false;
        while (true) {
          int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);

          int activitiesInSegment = 0;
          for (Activity activity in currentTimeFrameActivities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + (Duration.millisecondsPerDay * daysInMonth))))
              activitiesInSegment++;
          }
          if (activitiesInSegment > maxActivitiesInSegment)
            maxActivitiesInSegment = activitiesInSegment;

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));

          if (lastCycleIteration) return maxActivitiesInSegment;
          if (beginningOfTheTimeFrame.month == 12) lastCycleIteration = true;
        }
    }
    throw "Such timeframe does not exist";
  }

  //1 segment = 1 day for week and month, 10 days for year
  static getNumberOfActivitiesPerSegment(List<Activity> activities, StatsGraphTimeFrame timeFrame, DateTime beginningOfTheTimeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK:
        List<int> numberOfActivitiesPerSegment = List<int>();
        for (int i = 0; i < 7; i++) {
          int activitiesInSegment = 0;
          for (Activity activity in activities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + Duration.millisecondsPerDay)))
              activitiesInSegment++;
          }
          numberOfActivitiesPerSegment.add(activitiesInSegment);

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));
        }
        return numberOfActivitiesPerSegment;
      case StatsGraphTimeFrame.MONTH:
        List<int> numberOfActivitiesPerSegment = List<int>();
        int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);
        for (int i = 0; i < daysInMonth; i++) {
          int activitiesInSegment = 0;
          for (Activity activity in activities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + Duration.millisecondsPerDay)))
              activitiesInSegment++;
          }
          numberOfActivitiesPerSegment.add(activitiesInSegment);

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: 1));
        }
        return numberOfActivitiesPerSegment;
      case StatsGraphTimeFrame.YEAR:
        List<int> numberOfActivitiesPerSegment = List<int>();

        for (int i = 0; i < 12; i++) {
          int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);
          int activitiesInSegment = 0;
          for (Activity activity in activities) {
            if (DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal().isAfter(beginningOfTheTimeFrame)
                &&
                DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal()
                    .isBefore(DateTime.fromMillisecondsSinceEpoch(beginningOfTheTimeFrame.millisecondsSinceEpoch + (Duration.millisecondsPerDay * daysInMonth))))
              activitiesInSegment++;
          }
          numberOfActivitiesPerSegment.add(activitiesInSegment);

          beginningOfTheTimeFrame = beginningOfTheTimeFrame.add(
              Duration(days: daysInMonth));
        }
        return numberOfActivitiesPerSegment;
        break;
    }
  }
}

enum StatsGraphTimeFrame{
  WEEK, MONTH, YEAR
}
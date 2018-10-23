import 'package:useful_app/models/Event.dart';

class SessionDataModel {
  SessionDataModel();

  List<Event> _events = new List<Event>();
  List<Event> get events => _events;
  set events(List<Event> events) => _events = events;

  int _pageId = 0;
  int get pageId => _pageId;
  set pageId(pageId) => _pageId = pageId;

  StatsGraphTimeFrame _graphTimeFrame = StatsGraphTimeFrame.WEEK;
  StatsGraphTimeFrame get graphTimeFrame => _graphTimeFrame;
  set graphTimeFrame(graphTimeFrame) => _graphTimeFrame;
}



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
        beginningOfTheWeek.subtract(
            Duration(hours: beginningOfTheWeek.hour, minutes: beginningOfTheWeek.minute, seconds: beginningOfTheWeek.second));
        //reset weekday to monday
        beginningOfTheWeek.subtract(
            Duration(days: beginningOfTheWeek.weekday - 1));

        return beginningOfTheWeek;
      case StatsGraphTimeFrame.MONTH:
        DateTime beginningOfTheMonth = DateTime.now();
        beginningOfTheMonth = beginningOfTheMonth.toLocal();

        //reset time to 00:00
        beginningOfTheMonth.subtract(
            Duration(hours: beginningOfTheMonth.hour, minutes: beginningOfTheMonth.minute, seconds: beginningOfTheMonth.second));
        //reset day to first of the month
        beginningOfTheMonth.subtract(
            Duration(days: beginningOfTheMonth.day - 1));

        return beginningOfTheMonth;
      case StatsGraphTimeFrame.YEAR:
        break;
    }
  }
}

enum StatsGraphTimeFrame{
  WEEK, MONTH, YEAR
}
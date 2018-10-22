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

class StatsGraphTimeFrameDescriptor {
  static List<String> getStrings(StatsGraphTimeFrame timeFrame) {
    switch(timeFrame) {
      case StatsGraphTimeFrame.WEEK: return ["Mon", "Tues", "Wed", "Thu", "Fri", "Sat", "Sun"];
      case StatsGraphTimeFrame.MONTH: return ["07", "14", "21", "28"];
      case StatsGraphTimeFrame.YEAR: return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
    }
    throw "Such timeframe does not exist!";
  }
}

enum StatsGraphTimeFrame{
  WEEK, MONTH, YEAR
}
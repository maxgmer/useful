import 'package:flutter/material.dart';

import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/DateHelper.dart';
import 'package:useful_app/util/WidgetValues.dart';

class StatsGraph extends StatefulWidget {

  StatsGraph(List<Activity> activities, {Color graphMarkupColor, StatsGraphTimeFrame timeFrame, Color graphColor, int pageId}) {
    _StatsGraphState.pageId = pageId;
    _StatsGraphState.activities = activities;
    _StatsGraphState.timeFrame = timeFrame;
    _StatsGraphState.graphMarkupColor = graphMarkupColor;
    _StatsGraphState.graphColor = graphColor;
  }

  @override
  State<StatefulWidget> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> with TickerProviderStateMixin {
  static List<Activity> activities;

  static StatsGraphTimeFrame timeFrame;
  static Color graphMarkupColor;
  static Color graphColor;
  static int pageId;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(0.0, StatsGraphValues.SIZE),
      painter: _StatsGraphPainter(activities, pageId, timeFrame, graphMarkupColor, graphColor),
    );
  }
}

class _StatsGraphPainter extends CustomPainter {
  static const double _HEIGHT_SPACE_FOR_TEXT = 25.0;

  Animation animation;
  Color _graphMarkupColor;
  Color _graphColor;
  StatsGraphTimeFrame timeFrame;
  List<Activity> _activities;
  int _pageId;

  _StatsGraphPainter(this._activities, this._pageId, this.timeFrame, this._graphMarkupColor, this._graphColor);

  @override
  void paint(Canvas canvas, Size size) {
    //get beginning of the week time
    DateTime beginningOfTheTimeFrame = StatsGraphTimeFrameHelper.getTimeFrameBeginning(timeFrame);
    List<Activity> completedCurrentTimeFrameActivities = List<Activity>();
    //get activities for chosen time frame
    for (Activity activity in _activities) {
      if (beginningOfTheTimeFrame.isBefore(DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal())
          && activity.activityCompleted && activity.pageId == _pageId) {
        completedCurrentTimeFrameActivities.add(activity);
      }
    }

    int maxReachedGraphValue = StatsGraphTimeFrameHelper.getBestActivitiesNumber(timeFrame, completedCurrentTimeFrameActivities, beginningOfTheTimeFrame);
    int graphValueHeight = maxReachedGraphValue + (maxReachedGraphValue / 3).ceil();
    graphValueHeight = graphValueHeight + (5 - (graphValueHeight % 5));

    int fifthOfGraphValueHeight = (graphValueHeight / 5).round();

    Paint paint = new Paint()
        ..strokeWidth = StatsGraphValues.MARKUP_STROKE_WIDTH
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

    //draw horizontal markup lines and text values
    _drawHorizontalMarkupAndValues(canvas, paint, size, fifthOfGraphValueHeight);

    //draw vertical markup lines and values
    _drawVerticalMarkupAndValues(canvas, paint, size, beginningOfTheTimeFrame);

    //draw graph based on user data
    _drawGraph(canvas, paint, size, completedCurrentTimeFrameActivities, graphValueHeight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  TextPainter _getTextPainter(String text) {
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.black,
            fontSize: StatsGraphValues.FONT_SIZE_VERTICAL_MARKUP_TEXT,
            fontFamily: "Mali"
        ),
        text: (text));
    TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
    activitiesAmount.layout();
    return activitiesAmount;
  }

  void _drawHorizontalMarkupAndValues(Canvas canvas, Paint paint, Size size, int gapHeight) {
    paint.color = _graphMarkupColor;
    double fifthOfHeight = (size.height - (_HEIGHT_SPACE_FOR_TEXT * 2 /*2 because for bottom and top*/)) / 5;
    for (int i = 0, graphValueMarkupBase = 5; i <= 5; i++, graphValueMarkupBase--) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)),
          Offset(size.width, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)), paint);

      TextPainter text = _getTextPainter((graphValueMarkupBase * gapHeight).toString());
      text.paint(canvas,  Offset(0.0, 10.0 + (i * fifthOfHeight)));
    }
  }

  void _drawVerticalMarkupAndValues(Canvas canvas, Paint paint, Size size, DateTime beginningOfTheTimeFrame) {
    List<String> dayNames = StatsGraphTimeFrameHelper.getStrings(timeFrame);
    if (timeFrame != StatsGraphTimeFrame.MONTH) {
      double verticalMarkupLineGapWidth = (size.width - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE) / (dayNames.length - 1);
      for (int i = 0; i < dayNames.length; i++) {
        canvas.drawLine(
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * verticalMarkupLineGapWidth), _HEIGHT_SPACE_FOR_TEXT),
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * verticalMarkupLineGapWidth),
                size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

        TextPainter text = _getTextPainter(dayNames[i]);
        text.paint(canvas,
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * verticalMarkupLineGapWidth) - text.width / 2,
                size.height - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE / 2));
      }
    } else {
      int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);
      double graphDayWidth = (size.width - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE) / (daysInMonth - 1);
      double graphWeekWidth = graphDayWidth * 7;
      for (int i = 0; i < dayNames.length; i++) {
        canvas.drawLine(
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * graphWeekWidth), _HEIGHT_SPACE_FOR_TEXT),
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * graphWeekWidth),
                size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

        TextPainter text = _getTextPainter(dayNames[i]);
        text.paint(canvas,
            Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * graphWeekWidth) - text.width / 2,
                size.height - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE / 2));
      }
    }
  }

  void _drawGraph(Canvas canvas, Paint paint, Size size, List<Activity> completedCurrentTimeFrameActivities, int graphValueHeight) {
    paint.color = _graphColor;
    paint.strokeWidth = StatsGraphValues.GRAPH_LINE_STROKE_WIDTH;

    DateTime beginningOfTheTimeFrame = StatsGraphTimeFrameHelper.getTimeFrameBeginning(timeFrame);
    List<int> activitiesPerSegment = StatsGraphTimeFrameHelper.getNumberOfActivitiesPerSegment(completedCurrentTimeFrameActivities, timeFrame, beginningOfTheTimeFrame);

    double graphHeight = size.height - _HEIGHT_SPACE_FOR_TEXT * 2;
    double graphWidth = size.width - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE;
    double onePercentOfHeight = graphHeight / 100;
    double segmentWidth = graphWidth / (activitiesPerSegment.length - 1);
    for (int i = 0; i < activitiesPerSegment.length - 1; i++) {
      double currentPercentOfHeight = (graphValueHeight - (graphValueHeight - activitiesPerSegment[i])) / graphValueHeight * 100;
      double nextPercentOfHeight = (graphValueHeight - (graphValueHeight - activitiesPerSegment[i + 1])) / graphValueHeight * 100;
      canvas.drawLine(
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * segmentWidth),
              graphHeight - (onePercentOfHeight * currentPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT),
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + ((i + 1) * segmentWidth),
              graphHeight - (onePercentOfHeight * nextPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT),
          paint);

      canvas.drawCircle(
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + (i * segmentWidth),
              graphHeight - (onePercentOfHeight * currentPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT), StatsGraphValues.GRAPH_CIRCLE_RADIUS, paint);
      canvas.drawCircle(
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE + ((i + 1) * segmentWidth),
              graphHeight - (onePercentOfHeight * nextPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT), StatsGraphValues.GRAPH_CIRCLE_RADIUS, paint);
    }
  }
}
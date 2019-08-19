import 'package:flutter/material.dart';

import 'package:useful_app/models/activity.dart';
import 'package:useful_app/models/session_data_model.dart';
import 'package:useful_app/util/date_helper.dart';
import 'package:useful_app/util/widget_values.dart';

class StatsGraph extends StatefulWidget {

  StatsGraph(List<Activity> activities, {Color graphMarkupColor, StatsGraphTimeFrame timeFrame, Color graphLineColor, Color graphCircleColor, int pageId}) {
    _StatsGraphState.pageId = pageId;
    _StatsGraphState.activities = activities;
    _StatsGraphState.timeFrame = timeFrame;
    _StatsGraphState.graphMarkupColor = graphMarkupColor;
    _StatsGraphState.graphLineColor = graphLineColor;
    _StatsGraphState.graphCircleColor = graphCircleColor;
  }

  @override
  State<StatefulWidget> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> with TickerProviderStateMixin {

  static List<Activity> activities;

  static StatsGraphTimeFrame timeFrame;
  static Color graphMarkupColor;
  static Color graphLineColor;
  static Color graphCircleColor;
  static int pageId;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(0.0, StatsGraphValues.size),
      painter: _StatsGraphPainter(activities, pageId, timeFrame, graphMarkupColor, graphLineColor, graphCircleColor),
    );
  }
}

class _StatsGraphPainter extends CustomPainter {
  static const double _HEIGHT_SPACE_FOR_TEXT = 25.0;

  Animation animation;
  Color _graphMarkupColor;
  Color _graphColor;
  Color _graphCircleColor;
  StatsGraphTimeFrame timeFrame;
  List<Activity> _activities;
  int _pageId;


  _StatsGraphPainter(this._activities, this._pageId, this.timeFrame, this._graphMarkupColor, this._graphColor, this._graphCircleColor);

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
        ..strokeWidth = StatsGraphValues.markupStrokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

    _drawHeadline(canvas, paint, size);

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

  TextPainter _getTextPainter(String text, double fontSize) {
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontFamily: "Mali"
        ),
        text: (text));
    TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
    activitiesAmount.layout();
    return activitiesAmount;
  }

  void _drawHeadline(Canvas canvas, Paint paint, Size size) {
    TextPainter text = _getTextPainter(
        StatsGraphValues.getGraphHeadlineString(timeFrame),
        StatsGraphValues.fontSizeHeadline);

    text.paint(canvas, Offset(
        (StatsGraphValues.spaceForNumbersSize + size.width) / 2 -
            text.width / 2, 0.0));
  }

  void _drawHorizontalMarkupAndValues(Canvas canvas, Paint paint, Size size, int gapHeight) {
    paint.color = _graphMarkupColor;
    double fifthOfHeight = (size.height - (_HEIGHT_SPACE_FOR_TEXT * 2 /*2 because for bottom and top*/)) / 5;
    for (int i = 0, graphValueMarkupBase = 5; i <= 5; i++, graphValueMarkupBase--) {
      canvas.drawLine(Offset(StatsGraphValues.spaceForNumbersSize, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)),
          Offset(size.width, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)), paint);

      TextPainter text = _getTextPainter((graphValueMarkupBase * gapHeight).toString(),
          StatsGraphValues.fontSizeVerticalMarkupText);
      text.paint(canvas,  Offset(0.0, 10.0 + (i * fifthOfHeight)));
    }
  }

  void _drawVerticalMarkupAndValues(Canvas canvas, Paint paint, Size size, DateTime beginningOfTheTimeFrame) {
    List<String> dayNames = StatsGraphTimeFrameHelper.getStrings(timeFrame);
    if (timeFrame != StatsGraphTimeFrame.month) {
      double verticalMarkupLineGapWidth = (size.width - StatsGraphValues.spaceForNumbersSize) / (dayNames.length - 1);
      for (int i = 0; i < dayNames.length; i++) {
        canvas.drawLine(
            Offset(StatsGraphValues.spaceForNumbersSize + (i * verticalMarkupLineGapWidth), _HEIGHT_SPACE_FOR_TEXT),
            Offset(StatsGraphValues.spaceForNumbersSize + (i * verticalMarkupLineGapWidth),
                size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

        TextPainter text = _getTextPainter(dayNames[i], StatsGraphValues.fontSizeVerticalMarkupText);
        text.paint(canvas,
            Offset(StatsGraphValues.spaceForNumbersSize + (i * verticalMarkupLineGapWidth) - text.width / 2,
                size.height - StatsGraphValues.spaceForNumbersSize / 2));
      }
    } else {
      int daysInMonth = DateHelper.getDaysInCurrentMonth(beginningOfTheTimeFrame);
      double graphDayWidth = (size.width - StatsGraphValues.spaceForNumbersSize) / (daysInMonth - 1);
      double graphWeekWidth = graphDayWidth * 7;
      for (int i = 0; i < dayNames.length; i++) {
        canvas.drawLine(
            Offset(StatsGraphValues.spaceForNumbersSize + (i * graphWeekWidth), _HEIGHT_SPACE_FOR_TEXT),
            Offset(StatsGraphValues.spaceForNumbersSize + (i * graphWeekWidth),
                size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

        TextPainter text = _getTextPainter(dayNames[i], StatsGraphValues.fontSizeVerticalMarkupText);
        text.paint(canvas,
            Offset(StatsGraphValues.spaceForNumbersSize + (i * graphWeekWidth) - text.width / 2,
                size.height - StatsGraphValues.spaceForNumbersSize / 2));
      }
    }
  }

  void _drawGraph(Canvas canvas, Paint paint, Size size, List<Activity> completedCurrentTimeFrameActivities, int graphValueHeight) {
    paint.strokeWidth = StatsGraphValues.graphLineStrokeWidth;

    DateTime beginningOfTheTimeFrame = StatsGraphTimeFrameHelper.getTimeFrameBeginning(timeFrame);
    List<int> activitiesPerSegment = StatsGraphTimeFrameHelper.getNumberOfActivitiesPerSegment(completedCurrentTimeFrameActivities, timeFrame, beginningOfTheTimeFrame);

    double graphHeight = size.height - _HEIGHT_SPACE_FOR_TEXT * 2;
    double graphWidth = size.width - StatsGraphValues.spaceForNumbersSize;
    double onePercentOfHeight = graphHeight / 100;
    double segmentWidth = graphWidth / (activitiesPerSegment.length - 1);
    activitiesPerSegment = activitiesPerSegment.reversed.toList();
    while (true) {
      if (activitiesPerSegment.length == 0) break;
      if (activitiesPerSegment[0] == 0) {
        activitiesPerSegment.removeAt(0);
      } else break;
    }
    activitiesPerSegment = activitiesPerSegment.reversed.toList();
    for (int i = 0; i < activitiesPerSegment.length - 1; i++) {
      paint.color = _graphColor;
      double currentPercentOfHeight = (graphValueHeight - (graphValueHeight - activitiesPerSegment[i])) / graphValueHeight * 100;
      double nextPercentOfHeight = (graphValueHeight - (graphValueHeight - activitiesPerSegment[i + 1])) / graphValueHeight * 100;
      canvas.drawLine(
          Offset(StatsGraphValues.spaceForNumbersSize + (i * segmentWidth),
              graphHeight - (onePercentOfHeight * currentPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT),
          Offset(StatsGraphValues.spaceForNumbersSize + ((i + 1) * segmentWidth),
              graphHeight - (onePercentOfHeight * nextPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT),
          paint);

      paint.color = _graphCircleColor;
      canvas.drawCircle(
          Offset(StatsGraphValues.spaceForNumbersSize + (i * segmentWidth),
              graphHeight - (onePercentOfHeight * currentPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT), StatsGraphValues.graphCircleRadius, paint);
      canvas.drawCircle(
          Offset(StatsGraphValues.spaceForNumbersSize + ((i + 1) * segmentWidth),
              graphHeight - (onePercentOfHeight * nextPercentOfHeight) + _HEIGHT_SPACE_FOR_TEXT), StatsGraphValues.graphCircleRadius, paint);
    }
  }
}
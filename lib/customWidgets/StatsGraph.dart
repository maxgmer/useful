import 'package:flutter/material.dart';

import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/SessionDataModel.dart';
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

    paint.color = _graphMarkupColor;
    //draw horizontal markup lines and values
    double fifthOfHeight = (size.height - (_HEIGHT_SPACE_FOR_TEXT * 2 /*2 because for bottom and top*/)) / 5;
    for (int i = 0, graphValueMarkupBase = 5; i <= 5; i++, graphValueMarkupBase--) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)),
          Offset(size.width, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)), paint);

      _drawText(canvas, (graphValueMarkupBase * fifthOfGraphValueHeight).toString(), Offset(0.0, 10.0 + (i * fifthOfHeight)));
    }

    //draw vertical markup lines and values
    double shiftToRight = timeFrame == StatsGraphTimeFrame.YEAR ? 0.9 : 1.25;
    double shiftToRightText = timeFrame == StatsGraphTimeFrame.YEAR ? 0.70 : 1.0;
    List<String> dayNames = StatsGraphTimeFrameHelper.getStrings(timeFrame);
    double partOfWidth = size.width / dayNames.length;
    for (int i = 0; i < dayNames.length; i++) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRight + (i * partOfWidth), _HEIGHT_SPACE_FOR_TEXT),
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRight + (i * partOfWidth), size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

      _drawText(canvas, dayNames[i], Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRightText + (i * partOfWidth),
          size.height - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE / 2));
    }

    //draw graph data
    paint.color = _graphColor;

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  void _drawText(Canvas canvas, String text, Offset position) {
    TextSpan span = TextSpan(
        style: TextStyle(
            color: Colors.black,
            fontSize: StatsGraphValues.FONT_SIZE_VERTICAL_MARKUP_TEXT,
            fontFamily: "Mali"
        ),
        text: (text));
    TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
    activitiesAmount.layout();
    activitiesAmount.paint(canvas, position);
  }
}
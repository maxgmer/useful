import 'package:flutter/material.dart';

import 'package:useful_app/models/Activity.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/WidgetValues.dart';

class StatsGraph extends StatefulWidget {

  StatsGraph(List<Activity> activities, {Color graphMarkupColor, StatsGraphTimeFrame timeFrame}) {
    _StatsGraphState.activities = activities;
    _StatsGraphState.timeFrame = timeFrame;
    _StatsGraphState.graphMarkupColor = graphMarkupColor;
  }

  @override
  State<StatefulWidget> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> with TickerProviderStateMixin {
  static List<Activity> activities;

  static StatsGraphTimeFrame timeFrame;
  static Color graphMarkupColor;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(0.0, StatsGraphValues.SIZE),
      painter: _StatsGraphPainter(activities, timeFrame, graphMarkupColor),
    );
  }
}

class _StatsGraphPainter extends CustomPainter {
  static const double _HEIGHT_SPACE_FOR_TEXT = 25.0;

  Animation animation;
  Color lineColor;
  Color roundColor;
  Color _graphMarkupColor;
  StatsGraphTimeFrame timeFrame;
  List<Activity> activities;

  _StatsGraphPainter(this.activities, this.timeFrame, this._graphMarkupColor);

  @override
  void paint(Canvas canvas, Size size) {
    //get beginning of the week time
    DateTime beginningOfTheTimeFrame = StatsGraphTimeFrameHelper.getTimeFrameBeginning(timeFrame);
    List<Activity> currentTimeFrameActivities = List<Activity>();
    //get activities for chosen time frame
    for (Activity activity in activities) {
      if (beginningOfTheTimeFrame.isBefore(DateTime.fromMillisecondsSinceEpoch(activity.creationDate).toLocal())) {
        currentTimeFrameActivities.add(activity);
      }
    }
    int maxReachedGraphValue = StatsGraphTimeFrameHelper.getBestActivitiesNumber(timeFrame, currentTimeFrameActivities, beginningOfTheTimeFrame);

    int graphValueHeight = maxReachedGraphValue + (maxReachedGraphValue / 3).ceil();
    graphValueHeight = graphValueHeight + (5 - (graphValueHeight % 5));

    int fifthOfGraphValueHeight = (graphValueHeight / 5).round();

    Paint paint = new Paint()
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

    paint.color = _graphMarkupColor;
    //draw horizontal lines
    double fifthOfHeight = (size.height - (_HEIGHT_SPACE_FOR_TEXT * 2 /*2 because for bottom and top*/)) / 5;
    for (int i = 0; i <= 5; i++) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)),
          Offset(size.width, _HEIGHT_SPACE_FOR_TEXT + (i * fifthOfHeight)), paint);

      //move this to a separate method
      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: StatsGraphValues.FONT_SIZE_VERTICAL_MARKUP_TEXT,
              fontFamily: "Mali"
          ),
          text: (i * fifthOfGraphValueHeight).toString());
      TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
      activitiesAmount.layout();
      activitiesAmount.paint(canvas, Offset(0.0, 10.0 + (i * fifthOfHeight)));
    }


    //draw vertical lines
    double shiftToRight = timeFrame == StatsGraphTimeFrame.YEAR ? 0.9 : 1.25;
    double shiftToRightText = timeFrame == StatsGraphTimeFrame.YEAR ? 0.70 : 1.0;
    List<String> dayNames = StatsGraphTimeFrameHelper.getStrings(timeFrame);
    double partOfWidth = size.width / dayNames.length;
    for (int i = 0; i < dayNames.length; i++) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRight + (i * partOfWidth), _HEIGHT_SPACE_FOR_TEXT),
          Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRight + (i * partOfWidth), size.height - _HEIGHT_SPACE_FOR_TEXT), paint);

      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: StatsGraphValues.FONT_SIZE_HORIZONTAL_MARKUP_TEXT,
              fontFamily: "Mali"
          ),
          text: dayNames[i]);
      TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
      activitiesAmount.layout();
      activitiesAmount.paint(canvas, Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE * shiftToRightText + (i * partOfWidth),
          size.height - StatsGraphValues.SPACE_FOR_NUMBERS_SIZE / 2));
      }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
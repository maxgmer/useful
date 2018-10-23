import 'package:flutter/material.dart';

import 'package:useful_app/models/Event.dart';
import 'package:useful_app/models/SessionDataModel.dart';
import 'package:useful_app/util/WidgetValues.dart';

class StatsGraph extends StatefulWidget {

  StatsGraph(List<Event> events, {Color graphMarkupColor, StatsGraphTimeFrame timeFrame}) {
    _StatsGraphState.events = events;
    _StatsGraphState.timeFrame = timeFrame;
    _StatsGraphState.graphMarkupColor = graphMarkupColor;
  }

  @override
  State<StatefulWidget> createState() => _StatsGraphState();
}

class _StatsGraphState extends State<StatsGraph> with TickerProviderStateMixin {
  static List<Event> events;

  static StatsGraphTimeFrame timeFrame;
  static Color graphMarkupColor;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(0.0, StatsGraphValues.SIZE),
      painter: _StatsGraphPainter(events, timeFrame, graphMarkupColor),
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
  List<Event> events;

  _StatsGraphPainter(this.events, this.timeFrame, this._graphMarkupColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

    //get beginning of the week time
    DateTime beginningOfTheTimeFrame = StatsGraphTimeFrameHelper.getTimeFrameBeginning(timeFrame);

    List<Event> currentTimeFrameEvents = List<Event>();

    for (Event event in events) {
      if (beginningOfTheTimeFrame.isBefore(DateTime.fromMillisecondsSinceEpoch(event.creationDate).toLocal())) {
        currentTimeFrameEvents.add(event);
      }
    }

    int tasksDoneInATimeframe = 10;//tasksDoneInATimeframe + (int)(tasksDoneInATimeframe / 3) = max graph height value


    paint.color = _graphMarkupColor;
    //draw horizontal lines
    double fifthOfHeight = (size.height - (_HEIGHT_SPACE_FOR_TEXT * 2 /*for bottom and top*/)) / 5;
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
          text: (i + 1).toString());
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
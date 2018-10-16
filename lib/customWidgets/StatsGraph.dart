import 'package:flutter/material.dart';
import 'dart:math';

import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';

class StatsGraph extends StatefulWidget {

  StatsGraph({Color graphMarkupColor}) {
    _StatsGraphState.graphMarkupColor = graphMarkupColor;
  }

  @override
  State<StatefulWidget> createState() => _StatsGraphState();

}

class _StatsGraphState extends State<StatsGraph> with TickerProviderStateMixin {
  static Color graphMarkupColor;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(0.0, StatsGraphValues.SIZE),
      painter: _StatsGraphPainter(graphMarkupColor),
    );
  }
}

class _StatsGraphPainter extends CustomPainter {

  Animation animation;
  Color lineColor;
  Color roundColor;
  Color _graphMarkupColor;

  int maxTasksDoneInATimeframe = 10;//maxTasksDoneInATimeframe + (int)(maxTasksDoneInATimeframe / 3) = max graph height value

  _StatsGraphPainter(this._graphMarkupColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;

    paint.color = _graphMarkupColor;
    double fifthOfHeight = (size.height - 50) / 5;
    for (int i = 0; i <= 5; i++) {
      canvas.drawLine(Offset(StatsGraphValues.SPACE_FOR_NUMBERS_SIZE, 25 + (i * fifthOfHeight)), Offset(size.width, 25 + (i * fifthOfHeight)), paint);

      //move this to a separate method
      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.black,
              fontSize: StatsGraphValues.FONT_SIZE,
              fontFamily: "Mali"
          ),
          text: (i + 100).toString());
      TextPainter activitiesAmount = TextPainter(text: span, textDirection: TextDirection.ltr);
      activitiesAmount.layout();
      activitiesAmount.paint(canvas, Offset(0.0, 10.0 + (i * fifthOfHeight)));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:useful_app/util/widget_values.dart';

class CustomFloatingActionButton extends StatefulWidget {

  CustomFloatingActionButton(Function onClick, int pageId) {
    _CustomFABState.onClick = onClick;
    _CustomFABState.pageId = pageId;
  }

  @override
  State<StatefulWidget> createState() => new _CustomFABState();
}


class _CustomFABState extends State<CustomFloatingActionButton> with SingleTickerProviderStateMixin {
  bool _wasPressed = false;
  CurvedAnimation animation;
  AnimationController controller;

  double _latestFinalTopLeftX = CustomFABValues.calcRandomClipMain(),
      _latestFinalTopLeftY = CustomFABValues.calcRandomClipMain();
  double _nextTopLeftX, _nextTopLeftY;

  double _latestFinalTopRightX = CustomFABValues.calcRandomClipSecondary(),
      _latestFinalTopRightY = CustomFABValues.calcRandomClipSecondary();
  double _nextTopRightX, _nextTopRightY;

  double _latestFinalBottomLeftX = CustomFABValues.calcRandomClipSecondary(),
      _latestFinalBottomLeftY = CustomFABValues.calcRandomClipSecondary();
  double _nextBottomLeftX, _nextBottomLeftY;

  double _latestFinalBottomRightX = CustomFABValues.calcRandomClipMain(),
      _latestFinalBottomRightY = CustomFABValues.calcRandomClipMain();
  double _nextBottomRightX, _nextBottomRightY;

  double
  _topLeftX = 0.0, _topLeftY = 0.0,
  _topRightX = 0.0, _topRightY = 0.0,
  _bottomLeftX = 0.0, _bottomLeftY = 0.0,
  _bottomRightX = 0.0, _bottomRightY = 0.0;

  static int pageId;

  static Function _onClick;
  static set onClick(Function onClick) => _onClick = onClick;

  initState() {
    super.initState();
    _initNext();
    controller = AnimationController(
        duration: Duration(milliseconds: CustomFABValues.animationDuration), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut)
      ..addListener(() {
        setState(() {
          _topLeftX = _latestFinalTopLeftX + ((animation.value * _nextTopLeftX) - _latestFinalTopLeftX);
          _topLeftY = _latestFinalTopLeftY + ((animation.value * _nextTopLeftY) - _latestFinalTopLeftY);

          _topRightX = _latestFinalTopRightX + ((animation.value * _nextTopRightX) - _latestFinalTopRightX);
          _topRightY = _latestFinalTopRightY + ((animation.value * _nextTopRightY) - _latestFinalTopRightY);

          _bottomLeftX = _latestFinalBottomLeftX + ((animation.value * _nextBottomLeftX) - _latestFinalBottomLeftX);
          _bottomLeftY = _latestFinalBottomLeftY + ((animation.value * _nextBottomLeftY) - _latestFinalBottomLeftY);

          _bottomRightX = _latestFinalBottomRightX + ((animation.value * _nextBottomRightX) - _latestFinalBottomRightX);
          _bottomRightY = _latestFinalBottomRightY + ((animation.value * _nextBottomRightY) - _latestFinalBottomRightY);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _nextAnimation();
          _initNext();
        }
      });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: (_wasPressed ? (animation.value * CustomFABValues.interpolatablePaddingRight) :
      ((1 - animation.value) * CustomFABValues.interpolatablePaddingRight)) + CustomFABValues.minPaddingRight,
          bottom: (_wasPressed ? (animation.value * CustomFABValues.interpolatablePaddingBottom) :
          ((1 - animation.value) * CustomFABValues.interpolatablePaddingBottom)) + CustomFABValues.minPaddingBottom),
      child: RaisedButton(
        color: HomeScreenValues.getFABColor(animation.value, pageId),
        splashColor: Color.fromRGBO(0, 0, 0, 0.0), //no splash color
        padding: EdgeInsets.only(
            top: CustomFABValues.size,
            bottom: CustomFABValues.size,
            right: CustomFABValues.size / 2,
            left: CustomFABValues.size / 2),
        elevation: animation.value * CustomFABValues.maxElevation,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(_topLeftX, _topLeftY),
                topRight: Radius.elliptical(_topRightX, _topRightY),
                bottomLeft: Radius.elliptical(_bottomLeftX, _bottomLeftY),
                bottomRight: Radius.elliptical(_bottomRightX, _bottomRightY)
            )
        ),
        onPressed: () {
          _onClick();
          controller.forward(from: 0.0);
          _wasPressed = !_wasPressed;
        },
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initNext() {
    _nextTopLeftX = CustomFABValues.calcRandomClipMain();
    _nextTopLeftY = CustomFABValues.calcRandomClipMain();

    _nextTopRightX = CustomFABValues.calcRandomClipSecondary();
    _nextTopRightY = CustomFABValues.calcRandomClipSecondary();

    _nextBottomLeftX = CustomFABValues.calcRandomClipSecondary();
    _nextBottomLeftY = CustomFABValues.calcRandomClipSecondary();

    _nextBottomRightX = CustomFABValues.calcRandomClipMain();
    _nextBottomRightY = CustomFABValues.calcRandomClipMain();
  }

  void _nextAnimation() {
    _latestFinalBottomLeftX = _nextBottomLeftX;
    _latestFinalBottomLeftY = _nextBottomLeftY;

    _latestFinalBottomRightX = _nextBottomRightX;
    _latestFinalBottomRightY = _nextBottomRightY;

    _latestFinalTopLeftX = _nextTopLeftX;
    _latestFinalTopLeftY = _nextTopLeftY;

    _latestFinalTopRightX = _nextTopRightX;
    _latestFinalTopRightY = _nextTopRightY;
  }
}


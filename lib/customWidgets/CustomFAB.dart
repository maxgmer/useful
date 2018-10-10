import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final Function _onClick;

  CustomFloatingActionButton(this._onClick);


  @override
  State<StatefulWidget> createState() => new _CustomFABState(_onClick);
}


class _CustomFABState extends State<CustomFloatingActionButton> with SingleTickerProviderStateMixin {
  bool _wasPressed = false;
  CurvedAnimation animation;
  AnimationController controller;
  Function _onClick;

  double _latestFinalTopLeftX = _CustomFABValues.calcRandomClipMain(),
      _latestFinalTopLeftY = _CustomFABValues.calcRandomClipMain();
  double _nextTopLeftX, _nextTopLeftY;

  double _latestFinalTopRightX = _CustomFABValues.calcRandomClipSecondary(),
      _latestFinalTopRightY = _CustomFABValues.calcRandomClipSecondary();
  double _nextTopRightX, _nextTopRightY;

  double _latestFinalBottomLeftX = _CustomFABValues.calcRandomClipSecondary(),
      _latestFinalBottomLeftY = _CustomFABValues.calcRandomClipSecondary();
  double _nextBottomLeftX, _nextBottomLeftY;

  double _latestFinalBottomRightX = _CustomFABValues.calcRandomClipMain(),
      _latestFinalBottomRightY = _CustomFABValues.calcRandomClipMain();
  double _nextBottomRightX, _nextBottomRightY;

  double
  _topLeftX = 0.0, _topLeftY = 0.0,
  _topRightX = 0.0, _topRightY = 0.0,
  _bottomLeftX = 0.0, _bottomLeftY = 0.0,
  _bottomRightX = 0.0, _bottomRightY = 0.0;

  _CustomFABState(this._onClick);

  initState() {
    super.initState();
    _initNext();
    controller = AnimationController(
        duration: Duration(milliseconds: 600), vsync: this);
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
          right: (_wasPressed ? (animation.value * HomeScreenValues.INTERPOLATABLE_FAB_PADDING_RIGHT) :
      ((1 - animation.value) * HomeScreenValues.INTERPOLATABLE_FAB_PADDING_RIGHT)) + HomeScreenValues.MIN_FAB_PADDING_RIGHT,
          bottom: (_wasPressed ? (animation.value * HomeScreenValues.INTERPOLATABLE_FAB_PADDING_BOTTOM) :
          ((1 - animation.value) * HomeScreenValues.INTERPOLATABLE_FAB_PADDING_BOTTOM)) + HomeScreenValues.MIN_FAB_PADDING_BOTTOM),
      child: RaisedButton(
        color: HomeScreenValues.getFABColor(animation.value),
        splashColor: Color.fromRGBO(0, 0, 0, 0.0),
        padding: EdgeInsets.all(30.0),
        highlightColor: HomeScreenValues.getFABOnPressedColor(),
        elevation: animation.value * 10,
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
    _nextTopLeftX = _CustomFABValues.calcRandomClipMain();
    _nextTopLeftY = _CustomFABValues.calcRandomClipMain();

    _nextTopRightX = _CustomFABValues.calcRandomClipSecondary();
    _nextTopRightY = _CustomFABValues.calcRandomClipSecondary();

    _nextBottomLeftX = _CustomFABValues.calcRandomClipSecondary();
    _nextBottomLeftY = _CustomFABValues.calcRandomClipSecondary();

    _nextBottomRightX = _CustomFABValues.calcRandomClipMain();
    _nextBottomRightY = _CustomFABValues.calcRandomClipMain();
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

class _CustomFABValues {
  static const double _MAX_BUTTON_CLIP_SECONDARY = 40.0;
  static const double _MAX_BUTTON_CLIP_MAIN = 60.0;

  static const int _GUARANTEED_CLIP_MAIN = 5;
  static const int _GUARANTEED_CLIP_SECONDARY = 2;

  static double calcRandomClipMain() => Random().nextDouble() * _MAX_BUTTON_CLIP_MAIN + _GUARANTEED_CLIP_MAIN;
  static double calcRandomClipSecondary() => Random().nextDouble() * _MAX_BUTTON_CLIP_SECONDARY + _GUARANTEED_CLIP_SECONDARY;
}

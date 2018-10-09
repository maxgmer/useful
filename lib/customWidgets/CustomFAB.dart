import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:useful_app/blocs/HomeScreen/HomeScreenBloc.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final VoidCallback _onClick;

  CustomFloatingActionButton(this._onClick);


  @override
  State<StatefulWidget> createState() => new _CustomFABState(_onClick);
}


class _CustomFABState extends State<CustomFloatingActionButton> with SingleTickerProviderStateMixin {
  CurvedAnimation animation;
  AnimationController controller;
  VoidCallback _onClick;

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
  _topLeftX, _topLeftY,
  _topRightX, _topRightY,
  _bottomLeftX, _bottomLeftY,
  _bottomRightX, _bottomRightY;

  _CustomFABState(this._onClick);

  initState() {
    super.initState();
    _initNext();
    controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
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
        }
      });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return RaisedButton(
      color: HomeScreenValues.getFABColor(),
      padding: EdgeInsets.all(30.0),
      elevation: 6.0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(_topLeftX, _topLeftY),
              topRight: Radius.elliptical(_topRightX, _topRightY),
              bottomLeft: Radius.elliptical(_bottomLeftX, _bottomLeftY),
              bottomRight: Radius.elliptical(_bottomRightX, _bottomRightY)
          )
      ),
      onPressed: _onClick,
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
  static const double _MAX_BUTTON_CLIP_SECONDARY = 35.0;
  static const double _MAX_BUTTON_CLIP_MAIN = 40.0;

  static const int _GUARANTEED_CLIP_MAIN = 10;
  static const int _GUARANTEED_CLIP_SECONDARY = 5;

  static double calcRandomClipMain() => Random().nextDouble() * _MAX_BUTTON_CLIP_MAIN + _GUARANTEED_CLIP_MAIN;
  static double calcRandomClipSecondary() => Random().nextDouble() * _MAX_BUTTON_CLIP_SECONDARY + _GUARANTEED_CLIP_SECONDARY;
}

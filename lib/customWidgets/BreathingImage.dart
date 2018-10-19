import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:useful_app/util/WidgetValues.dart';

class BreathingImage extends StatefulWidget {

  BreathingImage(AssetImage image, {double size}) {
    _BreathingImageState.currentImg = image;
    _BreathingImageState.size = size;
  }

  @override
  State<StatefulWidget> createState() => new _BreathingImageState();
}


class _BreathingImageState extends State<BreathingImage> with SingleTickerProviderStateMixin {

  CurvedAnimation animation;
  AnimationController controller;

  static AssetImage currentImg;
  static double size;

  bool _shouldReverse = false;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: BreathingImageValues.ANIMATION_DURATION), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.linear)
      ..addListener(() {
        setState(() {
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          _shouldReverse = !_shouldReverse;
          _shouldReverse ? controller.reverse() : controller.forward();
        }
      });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return Image(
      image: currentImg,
      height: size + (BreathingImageValues.FULL_LUNGS_SIZE_ADDITION * animation.value),
      fit: BoxFit.fitHeight
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
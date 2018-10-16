import 'dart:ui';

class ColorHelper {

  static Color darken(Color colorToDarken, int darkenValue) {
    int newRed = colorToDarken.red - darkenValue;
    int newGreen = colorToDarken.green - darkenValue;
    int newBlue = colorToDarken.blue - darkenValue;
    return Color.fromRGBO(
        newRed < 0 ? 0 : newRed,
        newGreen < 0 ? 0 : newGreen,
        newBlue < 0 ? 0 : newBlue,
        colorToDarken.opacity
    );
  }
}
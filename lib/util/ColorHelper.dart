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

  static Color lighten(Color colorToLighten, int lightenValue) {
    int newRed = colorToLighten.red + lightenValue;
    int newGreen = colorToLighten.green + lightenValue;
    int newBlue = colorToLighten.blue + lightenValue;
    return Color.fromRGBO(
        newRed > 255 ? 255 : newRed,
        newGreen > 255 ? 255 : newGreen,
        newBlue > 255 ? 255 : newBlue,
        colorToLighten.opacity
    );
  }

  static Color addRed(Color pageAccentColor, int redToAdd) => Color.fromRGBO(
      pageAccentColor.red + redToAdd > 255 ? 255 : pageAccentColor.red + redToAdd,
      pageAccentColor.green, pageAccentColor.blue, pageAccentColor.opacity);


  static Color addGreen(Color pageAccentColor, int greenToAdd) => Color.fromRGBO(pageAccentColor.red,
      pageAccentColor.green + greenToAdd > 255 ? 255 : pageAccentColor.green + greenToAdd,
      pageAccentColor.blue, pageAccentColor.opacity);

  static Color addBlue(Color pageAccentColor, int blueToAdd) => Color.fromRGBO(
      pageAccentColor.red, pageAccentColor.green,
      pageAccentColor.blue + blueToAdd > 255 ? 255 : pageAccentColor.blue + blueToAdd,
      pageAccentColor.opacity);
}
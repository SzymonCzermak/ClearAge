import 'package:flutter/material.dart';

class AppStyles {
  // Gradient dla tła
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.15, 0.85, 1],
    colors: [
      Color.fromARGB(183, 0, 192, 115), // Zielony w lewym górnym rogu
      Colors.black, // Czerń dla przejścia
      Colors.black, // Czerń dla przejścia
      Color.fromARGB(199, 115, 0, 209), // Fioletowy w prawym dolnym rogu
    ],
  );

  // Gradient dla przycisku
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color.fromARGB(103, 115, 0, 209), // Kolor lewy
      Color.fromARGB(103, 0, 192, 115), // Kolor prawy
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Styl przycisku
  static BoxDecoration buttonDecoration = BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: Colors.white, // Kolor ramki
      width: 1, // Grubość ramki
    ),
  );

  // Styl tekstu przycisku
  static TextStyle buttonTextStyle(double fontSize, Color color) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }

  // Animacja przezroczystości
  static Widget animatedOpacity({
    required bool isVisible,
    required Widget child,
    Duration duration = const Duration(seconds: 2),
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration,
      child: child,
    );
  }

  // Fade animacja dla nawigacji
  static Route createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

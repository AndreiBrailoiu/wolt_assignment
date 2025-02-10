import 'package:flutter/material.dart';

// shake animation for favorite button
class ShakeAnimation {
  late final AnimationController controller;
  late final Animation<double> animation;

  ShakeAnimation({required TickerProvider vsync}) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 300),
    );

    // define the shake animation sequence; currently, horizontal shake
    animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(controller);
  }

  void dispose() {
    controller.dispose();
  }

  void trigger() {
    controller.forward(from: 0); // start the shake animation
  }
}

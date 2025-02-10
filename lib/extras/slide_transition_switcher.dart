import 'package:flutter/material.dart';

import '../screens/error_screen.dart';

// animation for updating the venues list
class SlideTransitionSwitcher extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final Widget child;

  const SlideTransitionSwitcher({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500), // animation duration = 0.5s
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: _slideAndFadeTransition,
      child: _buildContent(),
    );
  }

  // define the transition builder with slide and fade effect
  Widget _slideAndFadeTransition(Widget child, Animation<double> animation) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3), // slight slide from top; current offset = 30%
      end: Offset.zero,
    ).animate(animation);

    final fadeAnimation = Tween<double>(
      begin: 0.0, // start with 0% opacity
      end: 1.0,
    ).animate(animation);

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }

  // build the content based on loading/error state
  Widget _buildContent() {
    if (isLoading) {
      // attempt to create a sense of continuity in between fading in/out animations
      return const Opacity(
        opacity: 0.3,);
    } else if (errorMessage != null) {
      return ErrorScreen(errorMessage: errorMessage!); // potential error screen
    } else {
      return child; // main content if no error or loading
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

// initial splash screen displayed to the user
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isDarkBackground = false;
  Timer? _backgroundTimer;

  @override
  void initState() {
    super.initState();

    // setup fade animation for the text and spinner
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    // change background color every second
    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _isDarkBackground = !_isDarkBackground;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _backgroundTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDarkBackground
                ? [Colors.blueGrey.shade800, Colors.black]
                : [Colors.blue.shade300, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // app title
                Text(
                  'VenueFinder',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // app logo
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(height: 20),
                // the screen feels empty without this
                Text(
                  'Loading venues, please wait...',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
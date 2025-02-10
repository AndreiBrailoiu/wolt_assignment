import 'dart:async';
import 'constants.dart';

// simulates a location change every 10 seconds
class LocationCycler {
  int _currentLocationIndex = 0;
  late Timer _timer; // timer to cycle through locations
  final Duration interval; // interval to change locations
  final Function(int) onLocationChange; // callback to notify when the location changes

  // constructor to initialize the location cycler with the callback and interval
  LocationCycler({required this.onLocationChange, this.interval = const Duration(seconds: 10)});

  // start the timer at the given interval
  void start() {
    _timer = Timer.periodic(interval, (timer) {
      // update the current location index
      // modulo the index by the number of locations to cycle back to the first location when the last location is reached
      _currentLocationIndex = (_currentLocationIndex + 1) % locations.length;
      onLocationChange(_currentLocationIndex);
    });
  }

  void stop() {
    _timer.cancel();
  }

  // get the current location index
  int get currentIndex => _currentLocationIndex;
}

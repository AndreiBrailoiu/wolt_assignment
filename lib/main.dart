import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/error_screen.dart';
import 'services/venue_service.dart';
import 'services/favorite_service.dart';
import 'models/venue.dart';

void main() {
  runApp(const MyApp());
}

// initial data fetching while displaying splash screen, hiding the empty home screen while awaiting to be populated
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // fetching initial data and favorites to populate the app
  Future<List<Venue>> _initializeApp() async {
    try {
      // fetch initial data here
      final List<Venue> venues = await VenueService.fetchVenues(0);
      final favoriteService = FavoriteService();
      await favoriteService.applyFavorites(venues);
      await Future.delayed(const Duration(seconds: 3)); // ensure splash screen is shown for at least 3 seconds
      return venues;
    } catch (e) {
      throw Exception('Failed to initialize app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<List<Venue>>(
        future: _initializeApp(), // initializing
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // show splash screen while loading
          } else if (snapshot.hasError) {
              return const ErrorScreen(errorMessage: 'Network Error',);
          } else if (snapshot.hasData) {
            return HomeScreen(initialVenues: snapshot.data!); // if the future completes successfully, show home screen
          } else {
            return const ErrorScreen(errorMessage: 'Unknown error occurred');
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(), // define home screen route
      },
    );
  }
}

// the FutureBuilder widget is used to build the app based on the state of the future returned by _initializeApp():
// if waiting, show the splash screen, if an error occurs, show the error screen, if data is available, show the home screen.
// when the future completes successfully, the home screen is shown withe the list of venues (snapshot.data).
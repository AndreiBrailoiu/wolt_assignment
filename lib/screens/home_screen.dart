import 'package:flutter/material.dart';
import '../services/venue_service.dart';
import '../services/favorite_service.dart';
import '../models/venue.dart';
import '../widgets/venue_list.dart';
import '../extras/location_cycler.dart';
import '../extras/slide_transition_switcher.dart';
import 'error_screen.dart';

// main screen displayed to the user
class HomeScreen extends StatefulWidget {
  final List<Venue>? initialVenues;

  const HomeScreen({super.key, this.initialVenues});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Venue>? _venues; // list of venues to display
  bool _isLoading = true; // tracks if data is loading
  String? _errorMessage; // holds error message
  final FavoriteService _favoriteService = FavoriteService(); // favorite service instance
  late LocationCycler _locationCycler; // location cycler instance

  @override
  void initState() {
    super.initState();
    _venues = widget.initialVenues;
    _isLoading = false;

    // initialize location cycler for location change
    _locationCycler = LocationCycler(onLocationChange: (index) {
      _fetchVenues(index); // fetch venues for the new location
    });
    _locationCycler.start();
  }

  @override
  void dispose() {
    _locationCycler.stop();
    super.dispose();
  }

  // fetch venues based on given location index
  Future<void> _fetchVenues(int locationIndex) async {
    setState(() => _isLoading = true);
    try {
      final venues = await VenueService.fetchVenues(locationIndex); // fetch venues from service
      await _favoriteService.applyFavorites(venues); // apply favorites to venues
      setState(() => _venues = venues); // update venues
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite(Venue venue) {
    setState(() {
      venue.isFavorite = !venue.isFavorite; // toggle favorite status
      _favoriteService.saveFavorite(venue); // save favorite status
    });
  }

  @override
  Widget build(BuildContext context) {
        if (_errorMessage != null) {
      //return ErrorScreen(errorMessage: _errorMessage!); // hiding the specific error message to the user
      return const ErrorScreen(errorMessage: 'Network Error'); // display ErrorScreen if there's an error
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VenueFinder',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade300,
        centerTitle: true,
        toolbarHeight: 35.0,
      ),
      body: SlideTransitionSwitcher(
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        child: _venues != null
            ? VenueList(
                venues: _venues!,
                onFavoriteToggle: _toggleFavorite,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
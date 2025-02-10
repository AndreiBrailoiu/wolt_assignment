import 'package:flutter/material.dart';
import '../models/venue.dart';
import 'venue_list_tile.dart';

// handling the creation of the list of venues
class VenueList extends StatelessWidget {
  final List<Venue> venues; // list of venues to display
  final void Function(Venue) onFavoriteToggle; // callback to toggle favorite status

  const VenueList({
    super.key,
    required this.venues,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    // build list view of given venues
    return ListView.builder(
      itemCount: venues.length, // number of venues
      itemBuilder: (context, index) {
        final venue = venues[index]; // get venue at given index
        return VenueListTile(
          venue: venue,
          onFavoriteToggle: () => onFavoriteToggle(venue),
        );
      },
    );
  }
}

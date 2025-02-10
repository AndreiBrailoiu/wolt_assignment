import 'dart:convert';
import 'package:http/http.dart' as http;
import '../extras/constants.dart';
import '../models/venue.dart';

// service for fetching venues from the Wolt API and given locations
class VenueService {
  // fetch a list of venues based on the given location index
  static Future<List<Venue>> fetchVenues(int locationIndex) async {
    final lat = locations[locationIndex][0];
    final lon = locations[locationIndex][1];
    final url = Uri.parse('$baseUrl?lat=$lat&lon=$lon'); // construct the URL for the API request
    final response = await http.get(url); // send the GET request

    // parse the response if the request was successful (status code 200 = OK)
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // convert the JSON response to a Map
      // check if the 'sections' key exists and has at least 2 items
      if (data['sections'] != null && data['sections'].length > 1) {
        // return a list of Venue objects from the first 15 items in the second section
        return List<Venue>.from(
          data['sections'][1]['items'].take(15).map((item) => Venue.fromJson(item)),
        );
      } else {
        throw Exception('Unexpected data structure');
      }
    } else {
      // throw an exception if the request failed (status code is not 200)
      throw Exception('Failed to fetch venues');
    }
  }
}

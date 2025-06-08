import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vacaynest_app/models/hotel.dart';

class HotelApiService {
  final String _apiKey = 'AIzaSyD48Am8-FpXgS9l8O3iAm_p7f_1uyE8X6k';
  final String _detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';

  String _getPhotoUrl(String? photoReference) {
    if (photoReference == null || photoReference.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_apiKey';
  }

  Future<Hotel> fetchHotelDetails(String placeId) async {
    try {
      final uri = Uri.parse(
          '$_detailsUrl?place_id=$placeId&fields=name,rating,formatted_address,photos,geometry,reviews,website,formatted_phone_number&key=$_apiKey');
      final detailsResponse = await http.get(uri);

      if (detailsResponse.statusCode == 200) {
        final Map<String, dynamic> detailsData = json.decode(detailsResponse.body);
        final Map<String, dynamic>? details = detailsData['result'];

        if (details == null) {
          throw Exception('No details found for place id: $placeId');
        }

        String? photoReference;
        if (details['photos'] != null &&
            details['photos'] is List &&
            details['photos'].isNotEmpty) {
          photoReference = details['photos'][0]['photo_reference'];
        }

        return Hotel(
          name: details['name'] ?? 'No Name',
          imageUrl: _getPhotoUrl(photoReference),
          rating: (details['rating'] != null)
              ? (details['rating'] as num).toDouble()
              : 0.0,
          location: details['formatted_address'] ?? 'Location not available',
          price: 0.0,
          currency: 'USD',
          description: '',
          amenities: [],
          coordinates: {
            'latitude': details['geometry']?['location']?['lat'] ?? 0.0,
            'longitude': details['geometry']?['location']?['lng'] ?? 0.0,
          },
        );
      } else {
        throw Exception(
            'Failed to load hotel details. Status code: ${detailsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching hotel details: $e');
      throw Exception('Failed to connect to API: $e');
    }
  }
}
 
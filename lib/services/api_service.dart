import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _authority = 'geocoding-api.open-meteo.com';
  static const String _unencodedPathSearch = 'v1/search';

  

  Future<List<Map<String, dynamic>>> fetchDestinations() async {
    try {
      
      final response = await http.get(Uri.https(_authority, _unencodedPathSearch, {
        'name': 'city', 
        'count': '50',
        'language': 'en',
        'format': 'json',
      }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? results = data['results'];

        if (results != null && results.isNotEmpty) {
          return results.map((city) => {
            'id': city['id'].toString(),
            'name': city['name'] ?? '',
            'description': '${city['admin1'] ?? ''}, ${city['country'] ?? ''}'.trim(),
            'imageUrl': 'https://picsum.photos/500/300?random=${city['id']}',
            'rating': (city['id'] % 5) + 1.0, 
            'price': (city['id'] % 100 * 10) + 500.0, 
          }).toList();
        } else {
          return []; 
        }
      } else {
        throw Exception('Failed to load cities: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDestinationDetails(String id) async {
    try {
     
      final response = await http.get(Uri.https(_authority, _unencodedPathSearch, {
        'name': id, 
        'count': '1', 
        'language': 'en',
        'format': 'json',
      }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic>? results = data['results'];

        if (results != null && results.isNotEmpty) {
          final city = results.first;
          return {
            'id': city['id'].toString(),
            'name': city['name'] ?? '',
            'description': '${city['admin1'] ?? ''}, ${city['country'] ?? ''}'.trim(),
            'imageUrl': 'https://picsum.photos/500/300?random=${city['id']}',
            'rating': (city['id'] % 5) + 1.0,
            'price': (city['id'] % 100 * 10) + 500.0,
            'additionalInfo': {
              'Country': city['country'] ?? 'N/A',
              'Latitude': city['latitude'] ?? 'N/A',
              'Longitude': city['longitude'] ?? 'N/A',
              'Timezone': city['timezone'] ?? 'N/A',
              'Population': city['population'] ?? 'N/A',
            }
          };
        } else {
          throw Exception('City details not found');
        }
      } else {
        throw Exception('Failed to load city details: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching city details: $e');
    }
  }
} 
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  // 1. Connect to the internet to get data from a publicly available API
  static Future<Map<String, dynamic>?> fetchDataFromApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to load data from API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data from API: $e');
      return null;
    }
  }

  // 2. Provide an example of suitable content read from a local JSON file if the application is offline
  static Future<String> readLocalJsonFile(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      print('Error reading local JSON file: $e');
      return '{}'; // Return empty JSON on error
    }
  }

  // Example of suitable content for a local JSON file (assets/offline_data.json)
  // {
  //   "offers": [
  //     {
  //       "id": "1",
  //       "title": "Weekend Getaway Deal",
  //       "description": "20% off all bookings this weekend!",
  //       "image": "assets/images/offer1.jpg"
  //     },
  //     {
  //       "id": "2",
  //       "title": "Summer Holiday Special",
  //       "description": "Book 3 nights, get 1 free night.",
  //       "image": "assets/images/offer2.jpg"
  //     }
  //   ],
  //   "message": "Displaying offline data. Please connect to the internet for the latest offers."
  // }

  // 3. Read and write data to a local data source (using shared_preferences)

  // Write data to local storage
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    print('Saved $key: $value');
  }

  // Read data from local storage
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    print('Retrieved $key: $value');
    return value;
  }

  // Example of saving and retrieving a boolean
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    print('Saved $key: $value');
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(key);
    print('Retrieved $key: $value');
    return value;
  }
} 
import 'package:flutter/material.dart';
import 'package:vacaynest_app/screens/login.dart';
import 'package:vacaynest_app/screens/screen2.dart';
import 'package:vacaynest_app/screens/screen3.dart';
import 'package:vacaynest_app/screens/notifications.dart';
import 'package:vacaynest_app/models/hotel.dart';
import 'package:vacaynest_app/services/hotel_api_service.dart';
import 'package:vacaynest_app/data_manager.dart'; 
import 'dart:convert'; 
import 'package:vacaynest_app/screens/destinations.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:battery_plus/battery_plus.dart'; 
import 'package:geolocator/geolocator.dart'; 
import 'package:sensors_plus/sensors_plus.dart' show AccelerometerEvent;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContentScreen(),
    DestinationsScreen(),
    FavouriteScreen(),
    NotificationsScreen(),
    LoginScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: "Destinations"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  List<dynamic> _specialOffers = [];
  String _dataStatusMessage = 'Loading...';
  bool _isLoading = true;

 
  List<ConnectivityResult> _connectivityResult = [];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

 
  double _ambientLightValue = 0.0;
  late StreamSubscription<AccelerometerEvent> _lightSensorSubscription;

 
  final Battery _battery = Battery();
  int _batteryLevel = 100; 
  BatteryState _batteryState = BatteryState.unknown;
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  
  Position? _currentPosition;
  String _locationError = '';

  @override
  void initState() {
    super.initState();
    _fetchSpecialOffers();
    _checkLastFetchedTime();
    
    
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _connectivityResult = results;
      });
    });
    _initConnectivity();

    
    _lightSensorSubscription = SensorsPlatform.instance.accelerometerEvents.listen((AccelerometerEvent event) {
     
      setState(() {
        _ambientLightValue = event.x.abs() + event.y.abs() + event.z.abs();
      });
    });

    
    _initBatteryState();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });

   
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _lightSensorSubscription.cancel();
    _batteryStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (!mounted) return;
      setState(() {
        _connectivityResult = results;
      });
    } on Exception catch (e) {
      print('Could not check connectivity: $e');
    }
  }

  Future<void> _initBatteryState() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      setState(() {
        _batteryLevel = batteryLevel;
        _batteryState = batteryState;
      });
    } catch (e) {
      print('Could not get battery info: $e');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationError = 'Location services are disabled. Please enable the services.';
      });
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permissions are denied';
        });
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationError = 'Location permissions are permanently denied, we cannot request permissions.';
      });
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _locationError = ''; 
      });
    }).catchError((e) {
      setState(() {
        _locationError = 'Failed to get location: $e';
      });
    });
  }

  Future<void> _fetchSpecialOffers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final localJsonString = await DataManager.readLocalJsonFile('assets/offline_data.json');
      final localData = json.decode(localJsonString);
      setState(() {
        _specialOffers = localData['offers'];
        _dataStatusMessage = localData['message'] ?? 'Loaded from local data.';
      });
    } catch (e) {
      setState(() {
        _dataStatusMessage = 'Error loading local data: $e';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkLastFetchedTime() async {
    final lastFetchedTime = await DataManager.getString('last_fetched_time');
    if (lastFetchedTime != null) {
      print('Last fetched data at: $lastFetchedTime');
    } else {
      print('Data never fetched before.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 20),
          _buildSectionTitle("Recently Viewed"),
          _buildRecentlyViewed(context),
          SizedBox(height: 20),
          _buildSectionTitle("Getaways Near You"),
          _buildGetawaysList(),
          SizedBox(height: 20),
          _buildSectionTitle("Special Offers"),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildSpecialOffersList(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // Text(
               //   '${_dataStatusMessage} | Network: ${_connectivityResult.join(", ")} | Light: ${_ambientLightValue.toStringAsFixed(2)} lux',
               //   style: TextStyle(fontSize: 12, color: Colors.grey),
               // ),
                SizedBox(height: 4),
                Text(
                  'Battery: $_batteryLevel% (${_batteryState.name})',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  _locationError.isNotEmpty
                      ? 'Location: $_locationError'
                      : _currentPosition == null
                          ? 'Location: Fetching...'
                          : 'Location: ${_currentPosition!.latitude.toStringAsFixed(2)}, ${_currentPosition!.longitude.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) { // Accept context parameter
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFD19A00), // Temporarily hardcoding the color for debugging
        borderRadius: BorderRadius.vertical(
          bottom: Radius.zero,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              "VaycayNest",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Colombo",
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOption(Icons.calendar_today, "Apr 2 - Apr 9"),
              SizedBox(width: 10),
              _buildOption(Icons.person, "2"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black),
            SizedBox(width: 5),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRecentlyViewed(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HotelDetailsPage()));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://cf.bstatic.com/xdata/images/hotel/max1024x768/589978322.jpg?k=e8f823662c0108dcd5ed2f9f0af6321f9cbac8d24b9d91711ee36169ca04fe55&o=&hp=1",
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text("Tea house villa"),
          subtitle: Row(
            children: [Icon(Icons.star, size: 16, color: Theme.of(context).primaryColor), SizedBox(width: 5), Text("8.3")],
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }

  Widget _buildGetawaysList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildPlaceCard(
            "https://cf.bstatic.com/xdata/images/hotel/max1024x768/589978322.jpg?k=e8f823662c0108dcd5ed2f9f0af6321f9cbac8d24b9d91711ee36169ca04fe55&o=&hp=1",
            "Shangri-La Colombo", Theme.of(context).primaryColor
          ),
          _buildPlaceCard(
            "https://assets.minorhotels.com/image/upload/q_auto,f_auto/media/minor/nh/images/nh-collection-colombo/01_homepage/nhc_colombo_intro-image_944x510.jpg",
            "NH Collection Colombo", Theme.of(context).primaryColor
          ),
          _buildPlaceCard(
            "https://ik.imgkit.net/3vlqs5axxjf/external/ik-seo/https://media.iceportal.com/94959/photos/73212570_XL/Shangri-La-Hotel-Colombo-Exterior.jpg?tr=w-656%2Ch-390%2Cfo-auto",
            "Cinnamon Grand", Theme.of(context).primaryColor
          ),
          _buildPlaceCard(
            "https://cf.bstatic.com/xdata/images/hotel/max1024x768/92596537.jpg?k=76d4d96232a561d784302569ef71229dd97f25959c4c1704d960e6bf8b6b52b1&o=&hp=1",
            "Kingsbury Hotel", Theme.of(context).primaryColor
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String imageUrl, String name, Color starColor) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: starColor),
                      SizedBox(width: 4),
                      Text("8.3", style: TextStyle(fontSize: 12)), // Placeholder rating
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffersList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _specialOffers.map((offer) {
          return _buildOfferCard(
            offer['image'],
            offer['title'],
            offer['description'],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOfferCard(String imageUrl, String title, String description) {
    return SizedBox(
      width: 250, // Adjust width as needed
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.only(right: 16.0), // Add some spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

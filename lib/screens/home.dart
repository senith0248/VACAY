import 'package:flutter/material.dart';
import 'package:vacaynest_app/screens/login.dart';
import 'package:vacaynest_app/screens/screen2.dart';
import 'package:vacaynest_app/screens/screen3.dart';
import 'package:vacaynest_app/screens/notifications.dart';
import 'package:vacaynest_app/models/hotel.dart';
import 'package:vacaynest_app/services/hotel_api_service.dart';
import 'package:vacaynest_app/data_manager.dart'; // Import your DataManager
import 'dart:convert'; // Import dart:convert for json decoding
import 'package:vacaynest_app/screens/destinations.dart';

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
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFDAA804),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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

  @override
  void initState() {
    super.initState();
    _fetchSpecialOffers();
    _checkLastFetchedTime();
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
          _buildHeader(),
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
            child: Text(_dataStatusMessage, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFDAA804),
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
        // Navigate to Screen2 when the card is tapped
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
            children: const [Icon(Icons.star, size: 16, color: Color(0xFFDAA804)), SizedBox(width: 5), Text("8.3")],
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
            "Shangri-La Colombo",
          ),
          _buildPlaceCard(
            "https://assets.minorhotels.com/image/upload/q_auto,f_auto/media/minor/nh/images/nh-collection-colombo/01_homepage/nhc_colombo_intro-image_944x510.jpg",
            "NH Collection Colombo",
          ),
          _buildPlaceCard(
            "https://ik.imgkit.net/3vlqs5axxjf/external/ik-seo/https://media.iceportal.com/94959/photos/73212570_XL/Shangri-La-Hotel-Colombo-Exterior.jpg?tr=w-656%2Ch-390%2Cfo-auto",
            "Cinnamon Grand",
          ),
          _buildPlaceCard(
            "https://cf.bstatic.com/xdata/images/hotel/max1024x768/92596537.jpg?k=76d4d96232a561d784302569ef71229dd97f25959c4c1704d960e6bf8b6b52b1&o=&hp=1",
            "Kingsbury Hotel",
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String imageUrl, String name) {
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
                      Icon(Icons.star, size: 16, color: Color(0xFFDAA804)),
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

import 'package:flutter/material.dart';
import 'package:vacaynest_app/screens/login.dart';
import 'package:vacaynest_app/screens/screen2.dart';
import 'package:vacaynest_app/screens/screen3.dart';
import 'package:vacaynest_app/screens/notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContentScreen(),
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
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
          _buildSpecialOffersList(),
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
  top: Radius.zero, 
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
            children: [Icon(Icons.star, size: 16, color: Color(0xFFDAA804)), SizedBox(width: 5), Text("8.3")],
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
          _buildPlaceCard("Courtyard Colombo", "https://cf.bstatic.com/xdata/images/hotel/max1024x768/487077496.jpg?k=b396e891a3617668f450c80467fc4b4848ec709d0ff5381174724002e8785536&o=&hp=1"),
          SizedBox(width: 10),
          _buildPlaceCard("Marino Beach Colombo", "https://cf.bstatic.com/xdata/images/hotel/max1024x768/339811387.jpg?k=d5882457997dbcd333bd2d3e9b9d31025e64f08f5ae7f37cff1afde5ecaa2b6f&o=&hp=1"),
           _buildPlaceCard("The kingsbury colombo", "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/21/f4/4b/8f/the-kingsbury-hotel.jpg?w=700&h=-1&s=1"),
          SizedBox(width: 10),
          _buildPlaceCard("Grandbell hotel colombo", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNAseA5P3gNoDHBh7mWaaUlaW-47aj9dfpyg&s"),
        ],
      ),
    );
  }

  Widget _buildSpecialOffersList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildSpecialOfferCard("Luxury villa", "40% OFF", "https://assets.minorhotels.com/image/upload/q_auto,f_auto/media/minor/nh/images/nh-collection-colombo/01_homepage/nhc_colombo_intro-image_944x510.jpg"),
          SizedBox(width: 10),
          _buildSpecialOfferCard("Beachfront Villa", "30% OFF", "https://ik.imgkit.net/3vlqs5axxjf/external/ik-seo/https://media.iceportal.com/94959/photos/73212570_XL/Shangri-La-Hotel-Colombo-Exterior.jpg?tr=w-656%2Ch-390%2Cfo-auto"),
            _buildSpecialOfferCard("Luxury villa", "25% OFF", "https://cf.bstatic.com/xdata/images/hotel/max1024x768/92596537.jpg?k=76d4d96232a561d784302569ef71229dd97f25959c4c1704d960e6bf8b6b52b1&o=&hp=1"),
          SizedBox(width: 10),
          _buildSpecialOfferCard("Beachfront Villa", "15% OFF", "https://cf.bstatic.com/xdata/images/hotel/max1024x768/445142858.jpg?k=c3c5e25ead2a87dfdc08ab49371b7471a0a6d4de000ac23e10da7ef65a964766&o=&hp=1"),
          
        ],
      ),
    );
  }

  Widget _buildPlaceCard(String title, String imageUrl) {
    return Container(
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
              child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOfferCard(String title, String discount, String imageUrl) {
  return Container(
    width: 180,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    discount,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}

}

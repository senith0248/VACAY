import 'package:flutter/material.dart';
import 'package:vacaynest_app/screens/home.dart'; 

class FavouriteScreen extends StatelessWidget {
  final List<Map<String, String>> favouriteHotels = [
    {
      "name": "Tea house villa",
      "rating": "8.3",
      "image": "https://cf.bstatic.com/xdata/images/hotel/max1024x768/589978322.jpg?k=e8f823662c0108dcd5ed2f9f0af6321f9cbac8d24b9d91711ee36169ca04fe55&o=&hp=1", 
    },
    {
      "name": "Grandbell hotel colombo",
      "rating": "8.7",
      "image": "https://granbellhotel.lk/wp-content/uploads/2025/04/Grandbell-Duluxe-Room-2-1720x790-1.jpg",
    },
    {
      "name": "Sheraton hotels colombo",
      "rating": "8.3",
      "image": "https://cache.marriott.com/content/dam/marriott-digital/si/apec/hws/c/cmbsi/en_us/photo/unlimited/assets/si-cmbsi-hotel-exterior-dusk-33992.jpg",
    },
    {
      "name": "Hotel Valencia Center",
      "rating": "8.7",
      "image": "https://cf.bstatic.com/xdata/images/hotel/max1024x768/592830319.jpg?k=1648410f8785e93138c31e8f413312c834bf394220d7eee2251cdf4204ac06ae&o=&hp=1", 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); 
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(position: offsetAnimation, child: child);
                },
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          "Favourite Places",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: favouriteHotels.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: favouriteHotels[index]["image"]!.isNotEmpty
                            ? Image.network(
                                favouriteHotels[index]["image"]!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 120,
                                color: Colors.grey[300],
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  favouriteHotels[index]["rating"]!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              favouriteHotels[index]["name"]!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "1 room 2 people night",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(Icons.favorite, color: Colors.red, size: 28),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

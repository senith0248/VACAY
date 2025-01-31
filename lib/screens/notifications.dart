import 'package:flutter/material.dart';
import 'package:vacaynest_app/screens/home.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 218, 168, 4),
        elevation: 0,
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationItem(
              "Booking Confirmed",
              "Your booking at Tea House Villa has been confirmed!",
              "2h ago",
              true,
            ),
            _buildNotificationItem(
              "Special Offer!",
              "Get 20% off on your next booking. Limited time only!",
              "5h ago",
              false,
            ),
            _buildNotificationItem(
              "New Destination Alert",
              "Check out the latest getaway spot near you.",
              "1 day ago",
              false,
            ),
            _buildNotificationItem(
              "Booking Reminder",
              "Your stay at Hotel Valencia Center starts tomorrow.",
              "1 day ago",
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, String time, bool isNew) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Icon(
          isNew ? Icons.notifications_active : Icons.notifications_none,
          color: Colors.amber,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (isNew)
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "New",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

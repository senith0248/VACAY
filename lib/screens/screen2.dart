import 'package:flutter/material.dart';
import 'package:vacaynest_app/services/api_service.dart';

class HotelDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Select room',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  'https://cf.bstatic.com/xdata/images/hotel/max1024x768/589978322.jpg?k=e8f823662c0108dcd5ed2f9f0af6321f9cbac8d24b9d91711ee36169ca04fe55&o=&hp=1', 
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.amber, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tea house villa',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '1 room 2 people',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        Text(
                          '67 €',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 5),
                      Text('8.3', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Text(
                              'See all 140 reviews',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tea House Villa offers a serene and cozy retreat with its traditional design and lush garden surroundings. '
                    'The tranquil tea garden and aromatic tea blends are the standout features. '
                    'The rooms, though intimate, are elegantly decorated and provide a peaceful atmosphere with essential comforts.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
Row(
  children: const [
    Icon(Icons.star, color: Colors.amber),
    SizedBox(width: 5),
    Text('8.0', style: TextStyle(fontSize: 16)),
  ],
),
SizedBox(height: 10),
Text(
  'Tea House Villa provides an intimate escape with its classic décor and breathtaking views of the surrounding hills. '
  'The tea-tasting sessions held in the garden are a unique experience. '
  'The rooms, while cozy, are well-appointed with charming furnishings that ensure a restful stay.',
  style: TextStyle(fontSize: 14, color: Colors.black87),
),
Row(
  children: const [
    Icon(Icons.star, color: Colors.amber),
    SizedBox(width: 5),
    Text('8.1', style: TextStyle(fontSize: 16)),
  ],
),
SizedBox(height: 10),
Text(
  'Tea House Villa is a peaceful sanctuary with its traditional architecture and lush greenery. '
  'The diverse selection of freshly brewed teas and the tranquil environment are perfect for unwinding. '
  'The rooms are compact but stylish, designed to make guests feel at home with comfort and warmth.',
  style: TextStyle(fontSize: 14, color: Colors.black87),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Hotel {
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final double price;
  final String currency;
  final String description;
  final List<String> amenities;
  final Map<String, dynamic> coordinates;

  Hotel({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.price,
    required this.currency,
    required this.description,
    required this.amenities,
    required this.coordinates,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      description: json['description'] as String,
      amenities: List<String>.from(json['amenities'] as List),
      coordinates: json['coordinates'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'location': location,
      'price': price,
      'currency': currency,
      'description': description,
      'amenities': amenities,
      'coordinates': coordinates,
    };
  }
} 
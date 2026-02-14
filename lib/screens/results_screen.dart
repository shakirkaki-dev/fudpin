import 'package:flutter/material.dart';
import 'restaurant_detail_screen.dart';
import '../data/dummy_data.dart';
import '../models/restaurant.dart';

class ResultsScreen extends StatelessWidget {
  final String food;
  final String distance;

  const ResultsScreen({
    super.key,
    required this.food,
    required this.distance,
  });

  // 🔹 Convert distance string (e.g. "500 m", "1 km") to KM
  double _parseDistanceToKm(String distance) {
    final parts = distance.split(' ');
    final value = double.tryParse(parts.first) ?? 0;
    final unit = parts.length > 1 ? parts[1] : 'km';

    if (unit == 'm') {
      return value / 1000; // meters → km
    }
    return value; // already km
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Correctly parsed max distance in KM
    final double maxDistance = _parseDistanceToKm(distance);

    // 🔹 Food + distance search logic
    final List<Restaurant> restaurants = dummyRestaurants.where((restaurant) {
      final bool foodMatch = restaurant.searchedFood.name
          .toLowerCase()
          .contains(food.toLowerCase());

      final bool distanceMatch =
          restaurant.distanceKm <= maxDistance;

      return foodMatch && distanceMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search info
            Text(
              'Food: "$food"',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Within: $distance",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 🔹 Results OR empty state
            Expanded(
              child: restaurants.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No restaurants found for "$food"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Within $distance',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final Restaurant restaurant = restaurants[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(restaurant.name),
                            subtitle: Text(
                              "${restaurant.address} • ${restaurant.distanceKm} km",
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantDetailScreen(
                                    restaurant: restaurant,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
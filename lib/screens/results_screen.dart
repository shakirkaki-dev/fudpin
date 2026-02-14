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

  double _parseDistanceToKm(String distance) {
    final parts = distance.split(' ');
    final value = double.tryParse(parts.first) ?? 0;
    final unit = parts.length > 1 ? parts[1] : 'km';

    if (unit == 'm') {
      return value / 1000;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final double maxDistance = _parseDistanceToKm(distance);

    List<Restaurant> restaurants = dummyRestaurants.where((restaurant) {
      final bool foodMatch = restaurant.searchedFood.name
          .toLowerCase()
          .contains(food.toLowerCase());

      final bool distanceMatch =
          restaurant.distanceKm <= maxDistance;

      return foodMatch && distanceMatch;
    }).toList();

    restaurants.sort(
        (a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF59E0B),
                  Color(0xFFFB923C),
                  Color(0xFFFDBA74),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Results",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  "Restaurants serving",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  food,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Within $distance",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 BODY
          Expanded(
            child: restaurants.isEmpty
                ? const Center(
                    child: Text(
                      "No restaurants found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        /// 🔥 LIST
                        Expanded(
                          child: ListView.builder(
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant =
                                  restaurants[index];
                              final bool isNearest =
                                  index == 0;

                              return _buildRestaurantCard(
                                context,
                                restaurant,
                                isNearest,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// 🔥 FOOTER RESTORED
                        Text(
                          "Showing ${restaurants.length} restaurants",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(
    BuildContext context,
    Restaurant restaurant,
    bool isNearest,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  restaurant: restaurant,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isNearest
                  ? Border.all(
                      color: const Color(0xFFF59E0B),
                      width: 1.5,
                    )
                  : Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                if (isNearest)
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B)
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Nearest restaurant to you",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      "${restaurant.distanceKm} km",
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  restaurant.address,
                  style:
                      TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
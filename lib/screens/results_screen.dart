import 'package:flutter/material.dart';
import 'restaurant_detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final String food;
  final String distance;
  final dynamic backendResults;

  const ResultsScreen({
    super.key,
    required this.food,
    required this.distance,
    required this.backendResults,
  });

  @override
  Widget build(BuildContext context) {
    final List resultsList =
        backendResults != null && backendResults["results"] != null
            ? backendResults["results"]
            : [];

    return Scaffold(
      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              /// HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: Color(0xFF5A3E36),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "You are looking for",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A5E55),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      food,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A3E36),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Within $distance",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A5E55),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${resultsList.length} restaurants serve $food near you",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A5E55),
                      ),
                    ),
                  ],
                ),
              ),

              /// RESULTS
              Expanded(
                child: resultsList.isEmpty
                    ? const Center(
                        child: Text(
                          "No restaurants found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A3E36),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        itemCount: resultsList.length,
                        itemBuilder: (context, index) {

                          final item = resultsList[index];
                          final bool isNearest = index == 0;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Material(
                              color: Colors.white,
                              elevation: 4,
                              shadowColor:
                                  Colors.black.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(18),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),

                                /// CARD CLICK
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RestaurantDetailScreen(
                                        restaurantId: item["restaurant_id"],
                                        foodItemId: item["food_item_id"],
                                        originalSearchFoodId: item["food_item_id"],
                                        distanceKm:
                                            (item["distance_km"] ?? 0)
                                                .toDouble(),
                                      ),
                                    ),
                                  );
                                },

                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      if (isNearest)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6A00)
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            "Nearest restaurant",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFFF6A00),
                                            ),
                                          ),
                                        ),

                                      /// RESTAURANT NAME
                                      Text(
                                        item["restaurant_name"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5A3E36),
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      /// FOOD NAME
                                      Text(
                                        item["food_name"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF7A5E55),
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      /// DISTANCE + PRICE
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Color(0xFFFF6A00),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${item["distance_km"]} km",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF5A3E36),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Text(
                                            "Starts ₹${item["starting_price"] ?? "-"}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF6A00),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      /// VIEW DETAILS BUTTON
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFFF6A00),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),

                                          /// BUTTON CLICK
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RestaurantDetailScreen(
                                                  restaurantId:
                                                      item["restaurant_id"],
                                                  foodItemId:
                                                      item["food_item_id"],
                                                  originalSearchFoodId:
                                                      item["food_item_id"],
                                                  distanceKm:
                                                      (item["distance_km"] ??
                                                              0)
                                                          .toDouble(),
                                                ),
                                              ),
                                            );
                                          },

                                          child: const Text(
                                              "View More Details"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
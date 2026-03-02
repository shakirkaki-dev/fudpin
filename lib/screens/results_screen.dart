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
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(26),
                bottomRight: Radius.circular(26),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  food,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Within $distance",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 BODY
          Expanded(
            child: resultsList.isEmpty
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
                    child: ListView.builder(
                      itemCount: resultsList.length,
                      itemBuilder: (context, index) {
                        final item = resultsList[index];
                        final bool isNearest = index == 0;

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
                                    builder: (_) =>
                                        RestaurantDetailScreen(
                                      restaurantId:
                                          item["restaurant_id"],
                                      foodItemId:
                                          item["food_item_id"],
                                      distanceKm:
                                          (item["distance_km"] ?? 0)
                                              .toDouble(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                  border: isNearest
                                      ? Border.all(
                                          color: const Color(
                                              0xFFF59E0B),
                                          width: 1.5,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    if (isNearest)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(
                                                bottom: 6),
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4),
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                                  0xFFF59E0B)
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(8),
                                        ),
                                        child: const Text(
                                          "Nearest restaurant",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: Color(
                                                0xFFF59E0B),
                                          ),
                                        ),
                                      ),

                                    Text(
                                      item["restaurant_name"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      item["food_name"],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                          "Starting ₹${item["starting_price"] ?? "-"}",
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "${item["distance_km"]} km",
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
          ),
        ],
      ),
    );
  }
}
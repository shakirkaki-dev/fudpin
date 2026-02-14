import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final FoodItem searchedFood = restaurant.searchedFood;
    final List<FoodItem> otherFoods = restaurant.otherItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),

      // ===== BODY =====
      body: Column(
        children: [
          // ===== SCROLLABLE CONTENT =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== RESTAURANT HEADER =====
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${restaurant.address} • ${restaurant.distanceKm} km",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // ===== SEARCHED FOOD (PRIMARY) =====
                  const Text(
                    "Your searched food",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    searchedFood.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        "₹${searchedFood.price}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        searchedFood.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: searchedFood.isAvailable
                            ? Colors.green
                            : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        searchedFood.isAvailable
                            ? "Available today"
                            : "Not available today",
                        style: TextStyle(
                          color: searchedFood.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text("⭐ ${searchedFood.rating}"),

                  const SizedBox(height: 12),
                  const Text(
                    "Variants",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  ...searchedFood.variants.map((v) {
                    return Text("• $v");
                  }).toList(),

                  const SizedBox(height: 12),
                  Text(searchedFood.description),

                  const SizedBox(height: 32),

                  // ===== OTHER ITEMS =====
                  const Text(
                    "Other items available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...otherFoods.map((food) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(food.name),
                        subtitle: Text("₹${food.price}"),
                        trailing: Icon(
                          food.isAvailable
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: food.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                        onTap: () {
                          showFoodBottomSheet(context, food);
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // ===== FIXED GET DIRECTIONS BUTTON =====
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Later: Google Maps integration
              },
              icon: const Icon(Icons.directions),
              label: const Text("Get Directions"),
            ),
          ),
        ],
      ),
    );
  }

  // ===== BOTTOM SHEET =====
  void showFoodBottomSheet(BuildContext context, FoodItem food) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text("Price: ₹${food.price}"),
              const SizedBox(height: 8),
              Text(
                food.isAvailable
                    ? "Available today"
                    : "Not available today",
                style: TextStyle(
                  color: food.isAvailable
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                "Variants",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              ...food.variants.map((v) {
                return Text("• $v");
              }).toList(),

              const SizedBox(height: 12),
              Text(food.description),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_restaurant_screen.dart';
import 'menu_management_screen.dart';

class RestaurantManagementScreen extends StatefulWidget {
  final Map restaurant;

  const RestaurantManagementScreen({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  State<RestaurantManagementScreen> createState() =>
      _RestaurantManagementScreenState();
}

class _RestaurantManagementScreenState
    extends State<RestaurantManagementScreen> {

  late Map restaurantData;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    restaurantData = Map.from(widget.restaurant);
  }

  Future<void> deleteRestaurant() async {

    setState(() {
      isDeleting = true;
    });

    try {

      final id = restaurantData["id"];

      await ApiService.deleteRestaurant(id);

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete restaurant"),
        ),
      );
    }

    setState(() {
      isDeleting = false;
    });
  }

  Future<void> openEditRestaurant() async {

    final updatedRestaurant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditRestaurantScreen(
          restaurant: restaurantData,
        ),
      ),
    );

    if (updatedRestaurant != null) {
      setState(() {
        restaurantData = updatedRestaurant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantData["name"]),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              restaurantData["name"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(restaurantData["address"] ?? ""),

            const SizedBox(height: 10),

            Text("Phone: ${restaurantData["phone"] ?? ""}"),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuManagementScreen(
                        restaurantId: restaurantData["id"],
                      ),
                    ),
                  );

                },
                icon: const Icon(Icons.restaurant_menu),
                label: const Text("Manage Menu"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: openEditRestaurant,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Restaurant"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isDeleting ? null : deleteRestaurant,
                icon: const Icon(Icons.delete),
                label: isDeleting
                    ? const Text("Deleting...")
                    : const Text("Delete Restaurant"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
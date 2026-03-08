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

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);
  static const secondaryText = Color(0xFF7A5E55);

  @override
  void initState() {
    super.initState();
    restaurantData = Map.from(widget.restaurant);
  }

  Future<void> deleteRestaurant() async {

    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Restaurant"),
          content: const Text(
              "Are you sure you want to delete this restaurant?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      },
    );

    if (confirm != true) return;

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
        elevation: 0,
        title: const Text("Restaurant Management"),
        backgroundColor: primaryOrange,
      ),

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// RESTAURANT CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      restaurantData["name"],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: primaryOrange),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            restaurantData["address"] ?? "",
                            style: const TextStyle(
                              color: secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.phone,
                            size: 18, color: primaryOrange),
                        const SizedBox(width: 6),
                        Text(
                          restaurantData["phone"] ?? "",
                          style: const TextStyle(
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                "Restaurant Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 20),

              /// MANAGE MENU
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text("Manage Menu"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
                ),
              ),

              const SizedBox(height: 14),

              /// EDIT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Restaurant"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: openEditRestaurant,
                ),
              ),

              const SizedBox(height: 14),

              /// DELETE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: isDeleting
                      ? const Text("Deleting...")
                      : const Text("Delete Restaurant"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: isDeleting ? null : deleteRestaurant,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
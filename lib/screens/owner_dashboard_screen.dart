import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'onboarding_screen.dart';
import 'add_restaurant_screen.dart';
import 'restaurant_management_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  List restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      final data = await ApiService.getMyRestaurants();

      setState(() {
        restaurants = data;
        isLoading = false;
      });
    } catch (e) {
      print("LOAD RESTAURANTS ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openAddRestaurant() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddRestaurantScreen(),
      ),
    );

    loadRestaurants();
  }

  void openRestaurant(Map restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RestaurantManagementScreen(
          restaurant: restaurant,
        ),
      ),
    );
  }

  Future<void> logout() async {
    await AuthService.clearTokens();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Dashboard"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : restaurants.isEmpty
              ? const Center(
                  child: Text(
                    "No restaurants yet.\nAdd your first restaurant.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(restaurant["name"]),
                        subtitle: Text(restaurant["address"] ?? ""),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          openRestaurant(restaurant);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: openAddRestaurant,
        child: const Icon(Icons.add),
      ),
    );
  }
}
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
        backgroundColor: const Color(0xFFFF6A00),
        actions: [
          TextButton.icon(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      /// BACKGROUND
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: isLoading
            ? const Center(child: CircularProgressIndicator())

            : restaurants.isEmpty
                /// EMPTY STATE
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Icon(
                            Icons.storefront,
                            size: 80,
                            color: Color(0xFFFF6A00),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "No Restaurants Added Yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "Add your restaurant and let nearby customers discover your delicious dishes.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5A3E36),
                            ),
                          ),

                          const SizedBox(height: 35),

                          /// BIG ADD RESTAURANT BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: openAddRestaurant,
                              icon: const Icon(Icons.add_business),

                              label: const Text(
                                "Add Your Restaurant",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6A00),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                /// RESTAURANT LIST
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {

                      final restaurant = restaurants[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: ListTile(

                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFF6A00),
                            child: Icon(
                              Icons.restaurant,
                              color: Colors.white,
                            ),
                          ),

                          title: Text(
                            restaurant["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            restaurant["address"] ?? "",
                          ),

                          trailing: const Icon(Icons.arrow_forward_ios),

                          onTap: () {
                            openRestaurant(restaurant);
                          },
                        ),
                      );
                    },
                  ),
      ),

      /// BIG BUTTON ALSO WHEN RESTAURANTS EXIST
      bottomNavigationBar: restaurants.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: openAddRestaurant,
                icon: const Icon(Icons.add_business),

                label: const Text(
                  "Add Another Restaurant",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
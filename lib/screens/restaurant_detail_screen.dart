import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;
  final int foodItemId;
  final int originalSearchFoodId;
  final double distanceKm;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.foodItemId,
    required this.originalSearchFoodId,
    required this.distanceKm,
  });

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends State<RestaurantDetailScreen> {

  bool isLoading = true;
  dynamic restaurantData;
  dynamic currentFood;
  List menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurantMenu();
  }

  Future<void> _fetchRestaurantMenu() async {

    try {

      final data =
          await ApiService.getRestaurantMenu(widget.restaurantId);

      final List menu = data["menu"] ?? [];

      currentFood = menu.firstWhere(
        (item) => item["id"] == widget.foodItemId,
        orElse: () => null,
      );

      setState(() {
        restaurantData = data;
        menuItems = menu;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

    }
  }

  Future<void> _callRestaurant() async {

    final phone = restaurantData["phone"];
    final Uri callUri = Uri.parse("tel:$phone");

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  Future<void> _openMaps() async {

    final lat = restaurantData["latitude"];
    final lng = restaurantData["longitude"];

    final Uri mapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(
        mapsUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (restaurantData == null) {
      return const Scaffold(
        body: Center(child: Text("Failed to load restaurant")),
      );
    }

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              /// BACK BUTTON
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Color(0xFF5A3E36),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// RESTAURANT INFO CARD
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        restaurantData["restaurant_name"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                          color: Color(0xFF5A3E36),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${widget.distanceKm} km away",
                        style: const TextStyle(
                          color: Color(0xFF7A5E55),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFFFF6A00),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              restaurantData["address"] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A5E55),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (restaurantData["landmark"] != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 4),
                          child: Text(
                            "Near ${restaurantData["landmark"]}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF7A5E55),
                            ),
                          ),
                        ),

                      const SizedBox(height: 6),

                      Row(
                        children: [

                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Color(0xFFFF6A00),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            restaurantData["phone"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5A3E36),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// CURRENT DISH
                      if (currentFood != null)
                        _foodDetailsCard(currentFood),

                      const SizedBox(height: 25),

                      const Text(
                        "Menu",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A3E36),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...menuItems.map((item) {

                        if (item["id"] ==
                            widget.foodItemId) {
                          return const SizedBox();
                        }

                        return _menuItemCard(item);

                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// ACTION BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [

            Expanded(
              child: ElevatedButton.icon(
                onPressed: _callRestaurant,
                icon: const Icon(Icons.call),
                label: const Text("Call"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.navigation),
                label: const Text("Navigate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TOP DISH DETAILS
  Widget _foodDetailsCard(dynamic item) {

    final bool isSearchedDish =
        item["id"] == widget.originalSearchFoodId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          if (isSearchedDish)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6A00)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "⭐ You searched for this",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6A00),
                ),
              ),
            ),

          Text(
            item["name"],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A3E36),
            ),
          ),

          if (item["description"] != null)
            Padding(
              padding:
                  const EdgeInsets.only(top: 4),
              child: Text(
                item["description"],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7A5E55),
                ),
              ),
            ),

          const SizedBox(height: 10),

          /// VARIANTS
          if (item["variants"] != null)
            ...item["variants"].map<Widget>((variant) {

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Text(variant["name"]),

                    Text(
                      "₹${variant["price"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6A00),
                      ),
                    ),
                  ],
                ),
              );

            }).toList(),

          /// SPECIFICATIONS
          if (item["specifications"] != null)
            ...item["specifications"].map<Widget>((spec) {

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    Text(spec["label"]),

                    Text(
                      spec["value"],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );

            }).toList(),
        ],
      ),
    );
  }

  /// MENU LIST ITEMS
  Widget _menuItemCard(dynamic item) {

    final bool isSearchedDish =
        item["id"] == widget.originalSearchFoodId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(

        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            if (isSearchedDish)
              Container(
                margin:
                    const EdgeInsets.only(bottom: 4),
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                decoration:
                    BoxDecoration(
                  color: const Color(
                          0xFFFF6A00)
                      .withOpacity(
                          0.15),
                  borderRadius:
                      BorderRadius
                          .circular(
                              6),
                ),
                child: const Text(
                  "⭐ You searched for this",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                    color: Color(
                        0xFFFF6A00),
                  ),
                ),
              ),

            Text(
              item["name"],
              style:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight
                        .w600,
                color: Color(
                    0xFF5A3E36),
              ),
            ),
          ],
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        onTap: () {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RestaurantDetailScreen(
                restaurantId:
                    widget
                        .restaurantId,
                foodItemId:
                    item["id"],
                originalSearchFoodId:
                    widget
                        .originalSearchFoodId,
                distanceKm:
                    widget
                        .distanceKm,
              ),
            ),
          );

        },
      ),
    );
  }
}
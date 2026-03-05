import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;
  final int foodItemId;
  final double distanceKm;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
    required this.foodItemId,
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
  dynamic searchedFood;
  List otherMenu = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurantMenu();
  }

  Future<void> _fetchRestaurantMenu() async {
    try {
      final data =
          await ApiService.getRestaurantMenu(widget.restaurantId);

      final List menuItems = data["menu"] ?? [];

      searchedFood = menuItems.firstWhere(
        (item) => item["id"] == widget.foodItemId,
        orElse: () => null,
      );

      otherMenu = menuItems
          .where((item) => item["id"] != widget.foodItemId)
          .toList();

      setState(() {
        restaurantData = data;
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
      await launchUrl(mapsUri,
          mode: LaunchMode.externalApplication);
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
      backgroundColor: const Color(0xFFFFF8F1),

      body: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
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
                  restaurantData["restaurant_name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${widget.distanceKm} km away",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  /// SELECTED FOOD
                  if (searchedFood != null)
                    Container(
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
                            searchedFood["name"],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ...searchedFood["variants"]
                              .map<Widget>((variant) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                                bottom:
                                                    8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(variant[
                                            "name"]),
                                        Text(
                                          "₹${variant["price"]}",
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),

                          const SizedBox(height: 16),

                          ...searchedFood[
                                  "specifications"]
                              .map<Widget>((spec) =>
                                  Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                                bottom:
                                                    6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                          spec["label"],
                                          style:
                                              const TextStyle(
                                            color: Colors
                                                .grey,
                                          ),
                                        ),
                                        Text(
                                          spec["value"],
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  /// OTHER MENU
                  if (otherMenu.isNotEmpty) ...[

                    const Text(
                      "Other Menu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    ...otherMenu.map<Widget>((item) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                                  16),
                        ),
                        child: ListTile(
                          title: Text(item["name"]),
                          subtitle: Text(
                              "Starting ₹${item["variants"].first["price"]}"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),

                          /// CLICKABLE FIX
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RestaurantDetailScreen(
                                  restaurantId:
                                      widget.restaurantId,
                                  foodItemId:
                                      item["id"],
                                  distanceKm:
                                      widget.distanceKm,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                  ],
                ],
              ),
            ),
          ),
        ],
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
                      const Color(0xFFF59E0B),
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
                icon:
                    const Icon(Icons.navigation),
                label: const Text("Navigate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFFB923C),
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
}
import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/food_item.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? _selectedFood;
  String _selectedDistance = "5 km";

  final List<String> _distances = [
    "2 km",
    "5 km",
    "10 km",
    "15 km",
  ];

  // 🔥 Extract unique food names
  List<String> get _foodSuggestions {
    final List<String> names = [];

    for (var restaurant in dummyRestaurants) {
      names.add(restaurant.searchedFood.name);
      for (var item in restaurant.otherItems) {
        names.add(item.name);
      }
    }

    return names.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔥 HERO SECTION (unchanged)
            Container(
              height: 270,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/images/food_bg.jpg",
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/dishway_logo.png",
                        height: 120,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Find food before you stop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔥 BODY
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Search food",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  /// 🔥 AUTOCOMPLETE FIELD
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _foodSuggestions.where((food) =>
                            food.toLowerCase().contains(
                                textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) {
                        _selectedFood = selection;
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: "Eg: Biryani, Pizza...",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 16),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Search within distance",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDistance,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _distances.map((String distance) {
                          return DropdownMenuItem<String>(
                            value: distance,
                            child: Text(distance),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDistance = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 🔥 CTA BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {

                        if (_selectedFood == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select a food item from suggestions"),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsScreen(
                              food: _selectedFood!,
                              distance: _selectedDistance,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Find Nearby Food",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      "Discover. Decide. Dine.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
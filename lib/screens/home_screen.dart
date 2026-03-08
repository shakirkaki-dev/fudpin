import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? _selectedFood;
  String _selectedDistance = "5 km";

  final TextEditingController _foodController = TextEditingController();

  final List<String> _distances = [
    "2 km",
    "5 km",
    "10 km",
    "15 km",
  ];

  double _extractDistanceValue(String distanceText) {
    return double.parse(distanceText.split(" ")[0]);
  }

  void _startSearch() async {

    if (_selectedFood == null || _selectedFood!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a food name")),
      );
      return;
    }

    try {

      final results = await ApiService.searchFood(
        query: _selectedFood!,
        latitude: 12.9716,
        longitude: 77.5946,
        radius: _extractDistanceValue(_selectedDistance),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            food: _selectedFood!,
            distance: _selectedDistance,
            backendResults: results,
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget sectionTitle(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 35,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6A00),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

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

              /// HEADER IMAGE + LOGO (Flexible)
              Flexible(
                child: Stack(
                  fit: StackFit.expand,
                  children: [

                    Image.asset(
                      "assets/images/food_bg.jpg",
                      fit: BoxFit.cover,
                    ),

                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),

                    Center(
                      child: Image.asset(
                        "assets/images/dishway_logo.png",
                        height: 140,
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// SEARCH CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0,4),
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      sectionTitle("What You Want To Eat Now"),

                      const SizedBox(height: 10),

                      TextField(
                        controller: _foodController,
                        decoration: InputDecoration(
                          hintText: "Eg: Biryani, Pizza...",
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6A00),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _selectedFood = value;
                        },
                      ),

                      const SizedBox(height: 20),

                      sectionTitle("Within Distance Of"),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: _selectedDistance,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6A00),
                              width: 1.5,
                            ),
                          ),
                        ),
                        items: _distances.map((distance) {
                          return DropdownMenuItem(
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

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _startSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6A00),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "SEARCH",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// FOOTER
              const Text(
                "DISCOVER. DECIDE. DINE.",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFF6A00),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
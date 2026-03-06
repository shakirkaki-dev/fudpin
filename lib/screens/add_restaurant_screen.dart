import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final phoneController = TextEditingController();

  double? latitude;
  double? longitude;

  bool isLoading = false;
  bool locationDetected = false;

  Future<void> detectLocation() async {

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission denied"),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      locationDetected = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Restaurant location detected successfully"),
      ),
    );
  }

  Future<void> createRestaurant() async {

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please detect location first"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      await ApiService.createRestaurant(
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        landmark: landmarkController.text,
        phone: phoneController.text,
        latitude: latitude!,
        longitude: longitude!,
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create restaurant"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Restaurant"),
        backgroundColor: const Color(0xFFFF6A00),
      ),

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  const SizedBox(height: 10),

                  /// HEADER
                  const Text(
                    "Add Your Restaurant",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A3E36),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Fill the details below so nearby customers can discover your restaurant and dishes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7A5E55),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// FORM CARD
                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0,4),
                        )
                      ],
                    ),

                    child: Column(
                      children: [

                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Restaurant Name",
                            prefixIcon: const Icon(Icons.restaurant),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: descriptionController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: "Address",
                            prefixIcon: const Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: landmarkController,
                          decoration: InputDecoration(
                            labelText: "Landmark",
                            prefixIcon: const Icon(Icons.place),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// LOCATION BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: locationDetected ? null : detectLocation,
                            icon: const Icon(Icons.my_location),

                            label: Text(
                              locationDetected
                                  ? "Location Detected ✓"
                                  : "Detect Restaurant Location",
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6A00),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// CREATE RESTAURANT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(

                      onPressed: isLoading ? null : createRestaurant,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6A00),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Create Restaurant",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
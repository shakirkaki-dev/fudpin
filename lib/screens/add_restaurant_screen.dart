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

  Widget inputField(
      TextEditingController controller,
      String label,
      IconData icon,
      {int lines = 1,
      TextInputType? type}) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: lines,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
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

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),

            child: Column(

              children: [

                const SizedBox(height: 10),

                const Text(
                  "Add Your Restaurant",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A3E36),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Fill details so nearby customers can discover your dishes.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A5E55),
                  ),
                ),

                const SizedBox(height: 10),

                /// FORM CARD
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                        )
                      ],
                    ),

                    child: Column(
                      children: [

                        inputField(
                          nameController,
                          "Restaurant Name",
                          Icons.restaurant,
                        ),

                        inputField(
                          descriptionController,
                          "Description",
                          Icons.description,
                          lines: 2,
                        ),

                        inputField(
                          addressController,
                          "Address",
                          Icons.location_on,
                          lines: 2,
                        ),

                        inputField(
                          landmarkController,
                          "Landmark",
                          Icons.place,
                        ),

                        inputField(
                          phoneController,
                          "Phone",
                          Icons.phone,
                          type: TextInputType.phone,
                        ),

                        const SizedBox(height: 8),

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
                              style: const TextStyle(fontSize: 13),
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6A00),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// STICKY CREATE BUTTON
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: SizedBox(
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
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
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
        ),
      ),
    );
  }
}
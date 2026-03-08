import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditRestaurantScreen extends StatefulWidget {
  final Map restaurant;

  const EditRestaurantScreen({
    super.key,
    required this.restaurant,
  });

  @override
  State<EditRestaurantScreen> createState() =>
      _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;
  late TextEditingController landmarkController;
  late TextEditingController phoneController;

  bool isSaving = false;

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.restaurant["name"]);

    descriptionController =
        TextEditingController(text: widget.restaurant["description"] ?? "");

    addressController =
        TextEditingController(text: widget.restaurant["address"]);

    landmarkController =
        TextEditingController(text: widget.restaurant["landmark"] ?? "");

    phoneController =
        TextEditingController(text: widget.restaurant["phone"] ?? "");
  }

  Future<void> saveRestaurant() async {

    setState(() {
      isSaving = true;
    });

    try {

      await ApiService.updateRestaurant(
        id: widget.restaurant["id"],
        name: nameController.text,
        description: descriptionController.text,
        address: addressController.text,
        landmark: landmarkController.text,
        phone: phoneController.text,
      );

      if (!mounted) return;

      Navigator.pop(context, {
        ...widget.restaurant,
        "name": nameController.text,
        "description": descriptionController.text,
        "address": addressController.text,
        "landmark": landmarkController.text,
        "phone": phoneController.text,
      });

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update restaurant"),
        ),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  InputDecoration inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryOrange),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Restaurant"),
        backgroundColor: primaryOrange,
        elevation: 0,
      ),

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Restaurant Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: inputStyle(
                  "Restaurant Name",
                  Icons.restaurant,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: descriptionController,
                decoration: inputStyle(
                  "Description",
                  Icons.description,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: addressController,
                decoration: inputStyle(
                  "Address",
                  Icons.location_on,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: landmarkController,
                decoration: inputStyle(
                  "Landmark",
                  Icons.place,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: inputStyle(
                  "Phone Number",
                  Icons.phone,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: isSaving ? null : saveRestaurant,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: isSaving
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Update Restaurant",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
}
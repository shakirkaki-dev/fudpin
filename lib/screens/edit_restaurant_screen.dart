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

      Navigator.pop(context);

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Restaurant"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Restaurant Name",
              ),
            ),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
              ),
            ),

            TextField(
              controller: landmarkController,
              decoration: const InputDecoration(
                labelText: "Landmark",
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSaving ? null : saveRestaurant,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Restaurant"),
            )

          ],
        ),
      ),
    );
  }
}
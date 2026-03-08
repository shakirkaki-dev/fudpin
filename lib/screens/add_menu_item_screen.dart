import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddMenuItemScreen extends StatefulWidget {
  final int restaurantId;

  const AddMenuItemScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, TextEditingController>> variants = [];
  List<Map<String, TextEditingController>> specifications = [];

  bool saving = false;

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);

  @override
  void initState() {
    super.initState();
    addVariant();
    addSpecification();
  }

  void addVariant() {
    setState(() {
      variants.add({
        "name": TextEditingController(),
        "price": TextEditingController(),
      });
    });
  }

  void addSpecification() {
    setState(() {
      specifications.add({
        "label": TextEditingController(),
        "value": TextEditingController(),
      });
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

  Future<void> saveDish() async {

    setState(() {
      saving = true;
    });

    List variantList = variants.map((v) {
      return {
        "name": v["name"]!.text,
        "price": double.tryParse(v["price"]!.text) ?? 0
      };
    }).toList();

    List specificationList = specifications.map((s) {
      return {
        "label": s["label"]!.text,
        "value": s["value"]!.text
      };
    }).toList();

    Map data = {
      "name": nameController.text,
      "description": descriptionController.text,
      "restaurant_id": widget.restaurantId,
      "variants": variantList,
      "specifications": specificationList
    };

    try {

      await ApiService.createMenuItem(data);

      if (!mounted) return;

      Navigator.pop(context, true);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add dish"),
        ),
      );

    }

    setState(() {
      saving = false;
    });
  }

  Widget variantCard(Map<String, TextEditingController> variant) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: variant["name"],
              decoration: inputStyle("Variant", Icons.fastfood),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: variant["price"],
              keyboardType: TextInputType.number,
              decoration: inputStyle("Price", Icons.currency_rupee),
            ),
          ),

        ],
      ),
    );
  }

  Widget specificationCard(Map<String, TextEditingController> spec) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Expanded(
            child: TextField(
              controller: spec["label"],
              decoration: inputStyle("Label", Icons.label),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: spec["value"],
              decoration: inputStyle("Value", Icons.notes),
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Dish"),
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
                "Dish Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: inputStyle("Dish Name", Icons.restaurant),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: descriptionController,
                decoration: inputStyle("Description", Icons.description),
              ),

              const SizedBox(height: 30),

              const Text(
                "Variants",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 10),

              ...variants.map((variant) => variantCard(variant)).toList(),

              TextButton.icon(
                onPressed: addVariant,
                icon: const Icon(Icons.add, color: primaryOrange),
                label: const Text(
                  "Add Variant",
                  style: TextStyle(color: primaryOrange),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Specifications",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 10),

              ...specifications
                  .map((spec) => specificationCard(spec))
                  .toList(),

              TextButton.icon(
                onPressed: addSpecification,
                icon: const Icon(Icons.add, color: primaryOrange),
                label: const Text(
                  "Add Specification",
                  style: TextStyle(color: primaryOrange),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: saving ? null : saveDish,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: saving
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Save Dish",
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
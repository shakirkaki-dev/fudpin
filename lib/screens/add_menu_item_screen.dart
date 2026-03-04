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

    print("CREATE MENU ITEM PAYLOAD:");
    print(data);

    try {

      final response = await ApiService.createMenuItem(data);

      print("CREATE MENU ITEM RESPONSE:");
      print(response);

      if (!mounted) return;

      Navigator.pop(context, true);

    } catch (e) {

      print("CREATE MENU ERROR:");
      print(e);

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Dish"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Dish Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: nameController,
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: descriptionController,
            ),

            const SizedBox(height: 30),

            const Text(
              "Variants",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            ...variants.map((variant) {

              return Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: variant["name"],
                      decoration: const InputDecoration(
                        labelText: "Variant Name",
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: variant["price"],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                    ),
                  ),

                ],
              );

            }).toList(),

            const SizedBox(height: 10),

            TextButton(
              onPressed: addVariant,
              child: const Text("+ Add Variant"),
            ),

            const SizedBox(height: 30),

            const Text(
              "Specifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            ...specifications.map((spec) {

              return Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: spec["label"],
                      decoration: const InputDecoration(
                        labelText: "Label",
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: spec["value"],
                      decoration: const InputDecoration(
                        labelText: "Value",
                      ),
                    ),
                  ),

                ],
              );

            }).toList(),

            const SizedBox(height: 10),

            TextButton(
              onPressed: addSpecification,
              child: const Text("+ Add Specification"),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : saveDish,
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text("Save Dish"),
              ),
            )

          ],
        ),
      ),
    );
  }
}
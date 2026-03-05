import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditMenuItemScreen extends StatefulWidget {

  final Map menuItem;

  const EditMenuItemScreen({super.key, required this.menuItem});

  @override
  State<EditMenuItemScreen> createState() => _EditMenuItemScreenState();
}

class _EditMenuItemScreenState extends State<EditMenuItemScreen> {

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  List variants = [];
  List specifications = [];

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.menuItem["name"] ?? "";
    _descController.text = widget.menuItem["description"] ?? "";

    variants = List.from(widget.menuItem["variants"] ?? []);
    specifications = List.from(widget.menuItem["specifications"] ?? []);
  }

  void addVariant() {

    setState(() {
      variants.add({
        "name": "",
        "price": 0
      });
    });

  }

  void addSpecification() {

    setState(() {
      specifications.add({
        "label": "",
        "value": ""
      });
    });

  }

  Future<void> updateDish() async {

    await ApiService.updateMenuItem(
      id: widget.menuItem["id"],
      name: _nameController.text,
      description: _descController.text,
      variants: variants,
      specifications: specifications,
    );

    if (!mounted) return;

    Navigator.pop(context, true);

  }

  Widget buildVariantRow(int index) {

    final variant = variants[index];

    return Row(
      children: [

        Expanded(
          child: TextFormField(
            initialValue: variant["name"],
            decoration: const InputDecoration(
              labelText: "Variant Name",
            ),
            onChanged: (value) {
              variant["name"] = value;
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: TextFormField(
            initialValue: variant["price"].toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Price",
            ),
            onChanged: (value) {
              variant["price"] = double.tryParse(value) ?? 0;
            },
          ),
        ),

        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              variants.removeAt(index);
            });
          },
        )

      ],
    );

  }

  Widget buildSpecificationRow(int index) {

    final spec = specifications[index];

    return Row(
      children: [

        Expanded(
          child: TextFormField(
            initialValue: spec["label"],
            decoration: const InputDecoration(
              labelText: "Label",
            ),
            onChanged: (value) {
              spec["label"] = value;
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: TextFormField(
            initialValue: spec["value"],
            decoration: const InputDecoration(
              labelText: "Value",
            ),
            onChanged: (value) {
              spec["value"] = value;
            },
          ),
        ),

        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              specifications.removeAt(index);
            });
          },
        )

      ],
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Dish"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Dish Name",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Variants",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...List.generate(
              variants.length,
              (index) => buildVariantRow(index),
            ),

            TextButton(
              onPressed: addVariant,
              child: const Text("+ Add Variant"),
            ),

            const SizedBox(height: 30),

            const Text(
              "Specifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...List.generate(
              specifications.length,
              (index) => buildSpecificationRow(index),
            ),

            TextButton(
              onPressed: addSpecification,
              child: const Text("+ Add Specification"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateDish,
                child: const Text("Update Dish"),
              ),
            )

          ],
        ),
      ),
    );

  }
}
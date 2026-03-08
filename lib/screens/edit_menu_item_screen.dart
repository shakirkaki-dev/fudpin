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

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.menuItem["name"] ?? "";
    _descController.text = widget.menuItem["description"] ?? "";

    variants = List.from(widget.menuItem["variants"] ?? []);
    specifications = List.from(widget.menuItem["specifications"] ?? []);
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
            child: TextFormField(
              initialValue: variant["name"],
              decoration: inputStyle("Variant", Icons.fastfood),
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
              decoration: inputStyle("Price", Icons.currency_rupee),
              onChanged: (value) {
                variant["price"] = double.tryParse(value) ?? 0;
              },
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                variants.removeAt(index);
              });
            },
          )

        ],
      ),
    );

  }

  Widget buildSpecificationRow(int index) {

    final spec = specifications[index];

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
            child: TextFormField(
              initialValue: spec["label"],
              decoration: inputStyle("Label", Icons.label),
              onChanged: (value) {
                spec["label"] = value;
              },
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextFormField(
              initialValue: spec["value"],
              decoration: inputStyle("Value", Icons.notes),
              onChanged: (value) {
                spec["value"] = value;
              },
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                specifications.removeAt(index);
              });
            },
          )

        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Dish"),
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
                controller: _nameController,
                decoration: inputStyle("Dish Name", Icons.restaurant),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: _descController,
                decoration: inputStyle("Description", Icons.description),
              ),

              const SizedBox(height: 30),

              const Text(
                "Variants",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 10),

              ...List.generate(
                variants.length,
                (index) => buildVariantRow(index),
              ),

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 10),

              ...List.generate(
                specifications.length,
                (index) => buildSpecificationRow(index),
              ),

              TextButton.icon(
                onPressed: addSpecification,
                icon: const Icon(Icons.add, color: primaryOrange),
                label: const Text(
                  "Add Specification",
                  style: TextStyle(color: primaryOrange),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(

                  onPressed: updateDish,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "Update Dish",
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
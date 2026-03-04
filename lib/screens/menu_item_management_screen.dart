import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MenuItemManagementScreen extends StatefulWidget {

  final Map menuItem;

  const MenuItemManagementScreen({
    Key? key,
    required this.menuItem,
  }) : super(key: key);

  @override
  State<MenuItemManagementScreen> createState() =>
      _MenuItemManagementScreenState();
}

class _MenuItemManagementScreenState
    extends State<MenuItemManagementScreen> {

  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    isAvailable = widget.menuItem["is_available"];
  }

  Future<void> toggleAvailability() async {

    try {

      await ApiService.updateMenuItem(
        id: widget.menuItem["id"],
        isAvailable: !isAvailable,
      );

      setState(() {
        isAvailable = !isAvailable;
      });

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update availability"),
        ),
      );

    }

  }

  Future<void> deleteDish() async {

    try {

      await ApiService.deleteMenuItem(widget.menuItem["id"]);

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete dish"),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    final item = widget.menuItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(item["name"]),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              item["name"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(item["description"] ?? ""),

            const SizedBox(height: 30),

            SwitchListTile(
              title: const Text("Available"),
              value: isAvailable,
              onChanged: (_) => toggleAvailability(),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Edit dish screen (later)
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Dish"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: deleteDish,
                icon: const Icon(Icons.delete),
                label: const Text("Delete Dish"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
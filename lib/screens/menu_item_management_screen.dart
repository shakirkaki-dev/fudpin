import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_menu_item_screen.dart';

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
  late Map item;

  @override
  void initState() {
    super.initState();

    item = widget.menuItem;
    isAvailable = item["is_available"];
  }

  Future<void> toggleAvailability() async {

    try {

      await ApiService.updateMenuItem(
        id: item["id"],
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

      await ApiService.deleteMenuItem(item["id"]);

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

  Future<void> openEditScreen() async {

    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditMenuItemScreen(menuItem: item),
      ),
    );

    if (updatedItem != null) {

      setState(() {
        item = updatedItem;
        isAvailable = updatedItem["is_available"];
      });

    }

  }

  @override
  Widget build(BuildContext context) {

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
                onPressed: openEditScreen,
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
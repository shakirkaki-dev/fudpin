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

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);
  static const secondaryText = Color(0xFF7A5E55);

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

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Dish"),
        content: const Text(
          "Are you sure you want to delete this dish?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      ),
    );

    if (confirm != true) return;

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

  Widget dishCard() {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEFE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: primaryOrange,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  item["name"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
              ),

            ],
          ),

          const SizedBox(height: 10),

          Text(
            item["description"] ?? "",
            style: const TextStyle(
              color: secondaryText,
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
        title: const Text("Dish Management"),
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

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// DISH CARD
              dishCard(),

              const SizedBox(height: 30),

              /// AVAILABILITY
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: SwitchListTile(
                  title: const Text(
                    "Dish Available",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: isAvailable,
                  activeColor: const Color.fromARGB(255, 9, 220, 16),
                  onChanged: (_) => toggleAvailability(),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              const SizedBox(height: 16),

              /// EDIT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: openEditScreen,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Dish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// DELETE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: deleteDish,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete Dish"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
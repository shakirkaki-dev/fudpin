import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_menu_item_screen.dart';
import 'menu_item_management_screen.dart';

class MenuManagementScreen extends StatefulWidget {

  final int restaurantId;

  const MenuManagementScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);

  @override
  State<MenuManagementScreen> createState() =>
      _MenuManagementScreenState();
}

class _MenuManagementScreenState
    extends State<MenuManagementScreen> {

  List menuItems = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMenu();
  }

  Future<void> loadMenu() async {

    try {

      final data = await ApiService.getRestaurantMenu(widget.restaurantId);

      setState(() {
        menuItems = data["menu"] ?? [];
        loading = false;
      });

    } catch (e) {

      print("MENU ERROR: $e");

      setState(() {
        loading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Menu"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMenuItemScreen(
                restaurantId: widget.restaurantId,
              ),
            ),
          );

          loadMenu();

        },
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : menuItems.isEmpty
              ? const Center(child: Text("No menu items yet"))
              : ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {

                    final item = menuItems[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(item["name"] ?? ""),
                        subtitle: Text(item["description"] ?? ""),
                        trailing: const Icon(Icons.chevron_right),

                        onTap: () async {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MenuItemManagementScreen(
                                menuItem: item,
                              ),
                            ),
                          );

                          loadMenu();

                        },
                      ),
                    );

                  },
                ),
    );
  }
}
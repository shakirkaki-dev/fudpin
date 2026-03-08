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

class _MenuManagementScreenState extends State<MenuManagementScreen> {

  List menuItems = [];
  bool loading = true;

  static const primaryOrange = Color(0xFFFF6A00);
  static const primaryText = Color(0xFF5A3E36);
  static const secondaryText = Color(0xFF7A5E55);

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

  Widget menuCard(item) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

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

      child: ListTile(

        leading: Container(
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

        title: Text(
          item["name"] ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryText,
            fontSize: 16,
          ),
        ),

        subtitle: Text(
          item["description"] ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: secondaryText,
          ),
        ),

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
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Restaurant Menu"),
        backgroundColor: primaryOrange,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryOrange,

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

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: loading
              ? const Center(child: CircularProgressIndicator())

              : menuItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(
                            Icons.restaurant_menu,
                            size: 60,
                            color: primaryOrange,
                          ),

                          SizedBox(height: 10),

                          Text(
                            "No menu items yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryText,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Tap + to add your first dish",
                            style: TextStyle(
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    )

                  : ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {

                        final item = menuItems[index];

                        return menuCard(item);
                      },
                    ),
        ),
      ),
    );
  }
}
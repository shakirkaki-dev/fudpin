import 'package:flutter/material.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedDistance;
  final TextEditingController foodController = TextEditingController();

  final List<String> distanceOptions = [
    '500 m',
    '1 km',
    '2 km',
    '5 km',
  ];

  @override
  void dispose() {
    foodController.dispose();
    super.dispose();
  }

  void _searchFood() {
    if (foodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a food to search'),
        ),
      );
      return;
    }

    if (selectedDistance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a distance'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          food: foodController.text.trim(),
          distance: selectedDistance!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 18),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.04),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/dishway_logo.png',
                    height: 180, // 🔥 Bigger logo
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Find food before you stop",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Search by food, not restaurant.",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= SEARCH SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'What would you like to eat?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: foodController,
                    decoration: const InputDecoration(
                      hintText: 'Search food (biryani, dosa, meals...)',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Search within',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    value: selectedDistance,
                    hint: const Text('Select distance'),
                    items: distanceOptions
                        .map(
                          (distance) => DropdownMenuItem(
                            value: distance,
                            child: Text(distance),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistance = value;
                      });
                    },
                    decoration: const InputDecoration(),
                  ),

                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _searchFood,
                      child: const Text(
                        'FIND FOOD NEAR ME',
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // ================= FOOTER =================
                  Center(
                    child: Column(
                      children: [
                        Divider(
                          thickness: 1,
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Discover. Decide. Dine.",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Your food discovery companion.",
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
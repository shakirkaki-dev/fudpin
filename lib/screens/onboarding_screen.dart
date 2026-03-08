import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [

                const SizedBox(height: 10),

                /// FOOD ILLUSTRATION
                Flexible(
                  child: Image.asset(
                    "assets/images/onboarding_food.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 6),

                /// LOGO
                Flexible(
                  child: Image.asset(
                    "assets/images/dishway_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 6),

                /// TAGLINE
                const Text(
                  "Find your favourite food before stopping",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A3E36),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                /// SUB TEXT
                const Text(
                  "Get the details of all restaurants nearby which serve your desired food",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A5E55),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                /// FEATURES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    FeatureItem(icon: Icons.search, label: "Search Dish"),
                    FeatureItem(icon: Icons.location_on, label: "Nearby"),
                    FeatureItem(icon: Icons.navigation, label: "Navigate"),
                  ],
                ),

                /// pushes buttons to bottom
                const Spacer(),

                /// CONTINUE AS GUEST
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF6A00),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Continue as Guest",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// LOGIN OWNER
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login as Restaurant Owner",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Icon(
            icon,
            size: 26,
            color: const Color(0xFFFF6A00),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF5A3E36),
          ),
        ),
      ],
    );
  }
}
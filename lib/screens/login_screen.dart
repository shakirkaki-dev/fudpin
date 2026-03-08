import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'owner_dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleLogin() async {

    setState(() {
      _isLoading = true;
    });

    try {

      final response = await ApiService.loginOwner(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final accessToken = response["access_token"];
      final refreshToken = response["refresh_token"];

      await AuthService.saveTokens(accessToken, refreshToken);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OwnerDashboardScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email or password"),
        ),
      );

    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_texture.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(

          child: Column(

            children: [

              const SizedBox(height: 20),

              /// LOGO
              Image.asset(
                "assets/images/dishway_logo.png",
                height: 110,
              ),

              const SizedBox(height: 10),

              /// TITLE
              const Text(
                "Restaurant Owner Login",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A3E36),
                ),
              ),

              const SizedBox(height: 6),

              /// MESSAGE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  "Add your restaurant and let nearby customers discover your dishes instantly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A5E55),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// LOGIN CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),

                child: Container(

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0,4),
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      /// EMAIL
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(

                          onPressed: _isLoading ? null : _handleLogin,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6A00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// BOTTOM SECTION (SAFE FROM NAV BAR)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),

                  child: Column(
                    children: [

                      const Text(
                        "Still your restaurant not on Dishway?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A3E36),
                        ),
                      ),

                      TextButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );

                        },

                        child: const Text(
                          "Register Account and Add Your Restaurant",
                          style: TextStyle(
                            color: Color(0xFFFF6A00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          children: const [

                            BenefitItem(
                              icon: Icons.visibility,
                              text: "Get discovered by nearby customers",
                            ),

                            SizedBox(height: 10),

                            BenefitItem(
                              icon: Icons.restaurant_menu,
                              text: "Show your dishes to people searching nearby",
                            ),

                            SizedBox(height: 10),

                            BenefitItem(
                              icon: Icons.phone,
                              text: "Let the world know about your special menus",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                    ],
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

class BenefitItem extends StatelessWidget {

  final IconData icon;
  final String text;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Icon(
          icon,
          color: const Color(0xFFFF6A00),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF5A3E36),
            ),
          ),
        ),
      ],
    );
  }
}
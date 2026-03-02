import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator base URL
  static const String baseUrl = "http://10.0.2.2:8000";

  // -------------------------
  // SEARCH FOOD
  // -------------------------
  static Future<dynamic> searchFood({
    required String query,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final uri = Uri.parse(
      "$baseUrl/search?food=$query&lat=$latitude&lng=$longitude&radius=$radius",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("SEARCH STATUS CODE: ${response.statusCode}");
      print("SEARCH BODY: ${response.body}");
      throw Exception("Failed to fetch search results");
    }
  }

  // -------------------------
  // GET RESTAURANT MENU
  // -------------------------
  static Future<dynamic> getRestaurantMenu(int restaurantId) async {
    final uri = Uri.parse(
      "$baseUrl/restaurants/$restaurantId/menu",
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("MENU STATUS CODE: ${response.statusCode}");
      print("MENU BODY: ${response.body}");
      throw Exception("Failed to fetch restaurant menu");
    }
  }
}
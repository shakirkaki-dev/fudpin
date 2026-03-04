import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {

  static const String baseUrl = "http://10.0.2.2:8000";

  // -------------------------
  // AUTH HEADER
  // -------------------------
  static Future<Map<String, String>> _getAuthHeaders() async {

    final token = await AuthService.getAccessToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

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

    print("SEARCH STATUS: ${response.statusCode}");
    print("SEARCH BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to search food");
  }

  // -------------------------
  // GET RESTAURANT MENU
  // -------------------------
  static Future<dynamic> getRestaurantMenu(int restaurantId) async {

    final uri = Uri.parse("$baseUrl/restaurants/$restaurantId/menu");

    final response = await http.get(uri);

    print("MENU STATUS: ${response.statusCode}");
    print("MENU BODY: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch restaurant menu");
  }

  // -------------------------
  // REGISTER OWNER
  // -------------------------
  static Future<dynamic> registerOwner({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {

    final uri = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Registration failed");
  }

  // -------------------------
  // LOGIN OWNER
  // -------------------------
  static Future<dynamic> loginOwner({
    required String email,
    required String password,
  }) async {

    final uri = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Login failed");
  }

  // -------------------------
  // CREATE RESTAURANT
  // -------------------------
  static Future<dynamic> createRestaurant({
    required String name,
    String? description,
    required String address,
    String? landmark,
    String? phone,
    required double latitude,
    required double longitude,
  }) async {

    final uri = Uri.parse("$baseUrl/restaurants/");

    final headers = await _getAuthHeaders();

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "name": name,
        "description": description,
        "address": address,
        "landmark": landmark,
        "phone": phone,
        "latitude": latitude,
        "longitude": longitude
      }),
    );

    print("CREATE RESTAURANT STATUS: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to create restaurant");
  }

  // -------------------------
  // GET MY RESTAURANTS
  // -------------------------
  static Future<dynamic> getMyRestaurants() async {

    final uri = Uri.parse("$baseUrl/restaurants/me");

    final headers = await _getAuthHeaders();

    final response = await http.get(uri, headers: headers);

    print("MY RESTAURANTS STATUS: ${response.statusCode}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to fetch restaurants");
  }

  // -------------------------
  // UPDATE RESTAURANT
  // -------------------------
  static Future<dynamic> updateRestaurant({
    required int id,
    required String name,
    String? description,
    required String address,
    String? landmark,
    String? phone,
  }) async {

    final uri = Uri.parse("$baseUrl/restaurants/$id");

    final headers = await _getAuthHeaders();

    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode({
        "name": name,
        "description": description,
        "address": address,
        "landmark": landmark,
        "phone": phone
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to update restaurant");
  }

  // -------------------------
  // DELETE RESTAURANT
  // -------------------------
  static Future<void> deleteRestaurant(int id) async {

    final uri = Uri.parse("$baseUrl/restaurants/$id");

    final headers = await _getAuthHeaders();

    final response = await http.delete(uri, headers: headers);

    print("DELETE STATUS: ${response.statusCode}");

    if (response.statusCode != 200) {
      throw Exception("Failed to delete restaurant");
    }
  }

}
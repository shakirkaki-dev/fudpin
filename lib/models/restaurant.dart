import 'food_item.dart';

class Restaurant {
  final String name;
  final String address;
  final double distanceKm;
  final FoodItem searchedFood;
  final List<FoodItem> otherItems;

  Restaurant({
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.searchedFood,
    required this.otherItems,
  });
}

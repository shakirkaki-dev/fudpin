import 'food_variant.dart';
import 'food_specification.dart';

class FoodItem {
  final String name;
  final List<FoodVariant> variants;
  final List<FoodSpecification> specifications;
  final bool isAvailable;
  final double rating;
  final String description;

  FoodItem({
    required this.name,
    required this.variants,
    required this.specifications,
    required this.isAvailable,
    required this.rating,
    required this.description,
  });
}
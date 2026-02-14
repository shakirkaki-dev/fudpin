class FoodItem {
  final String name;
  final double price;
  final bool isAvailable;
  final double rating;
  final String description;
  final List<String> variants;

  FoodItem({
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.rating,
    required this.description,
    required this.variants,
  });
}

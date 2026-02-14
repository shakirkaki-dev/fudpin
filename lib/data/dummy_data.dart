import '../models/food_item.dart';
import '../models/food_variant.dart';
import '../models/food_specification.dart';
import '../models/restaurant.dart';

final FoodItem biriyani = FoodItem(
  name: 'Chicken Biriyani',
  isAvailable: true,
  rating: 4.3,
  description: 'Traditional Malabar slow-cooked biriyani.',
  variants: [
    FoodVariant(name: 'Full', price: 180),
    FoodVariant(name: 'Half', price: 120),
  ],
  specifications: [
    FoodSpecification(label: 'Rice Type', value: 'Jeerakasala'),
    FoodSpecification(label: 'Chicken Type', value: 'Fried'),
    FoodSpecification(label: 'Served In', value: 'Banana Leaf'),
    FoodSpecification(label: 'Raita', value: 'Available'),
  ],
);

final FoodItem friedRice = FoodItem(
  name: 'Chicken Fried Rice',
  isAvailable: true,
  rating: 4.0,
  description: 'Classic Indo-Chinese fried rice.',
  variants: [
    FoodVariant(name: 'Regular', price: 150),
  ],
  specifications: [
    FoodSpecification(label: 'Rice Type', value: 'Basmati'),
    FoodSpecification(label: 'Chicken Type', value: 'Boneless'),
    FoodSpecification(label: 'Spice Level', value: 'Medium'),
  ],
);

final List<Restaurant> dummyRestaurants = [
  Restaurant(
    name: 'Hotel Rahmath',
    address: 'Main Road, Kozhikode',
    distanceKm: 2.4,
    searchedFood: biriyani,
    otherItems: [friedRice],
  ),
];
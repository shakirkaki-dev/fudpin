import '../models/food_item.dart';
import '../models/restaurant.dart';

final FoodItem biriyani = FoodItem(
  name: 'Chicken Biriyani',
  price: 180,
  isAvailable: true,
  rating: 4.3,
  description: 'Traditional Malabar style biriyani.',
  variants: ['Full', 'Half'],
);

final FoodItem friedRice = FoodItem(
  name: 'Chicken Fried Rice',
  price: 150,
  isAvailable: true,
  rating: 4.0,
  description: 'Classic Indo-Chinese fried rice.',
  variants: [],
);
final FoodItem beefFry = FoodItem(
  name: 'Beef Fry',
  price: 220,
  isAvailable: true,
  rating: 4.2,
  description: 'Spicy Kerala style beef fry with coconut slices.',
  variants: ['Normal'],
);

final FoodItem gheeRice = FoodItem(
  name: 'Ghee Rice',
  price: 140,
  isAvailable: true,
  rating: 4.1,
  description: 'Aromatic ghee rice with cashews and raisins.',
  variants: ['Single'],
);


final List<Restaurant> dummyRestaurants = [
  Restaurant(
    name: 'Hotel Rahmath',
    address: 'Main Road, Kozhikode',
    distanceKm: 2.4,
    searchedFood: biriyani,
    otherItems: [friedRice],
  ),
  Restaurant(
  name: 'Paragon Restaurant',
  address: 'SM Street, Kozhikode',
  distanceKm: 3.1,
  searchedFood: biriyani,
  otherItems: [beefFry, gheeRice],
 ),

 Restaurant(
  name: 'Top Form',
  address: 'Beach Road, Kozhikode',
  distanceKm: 4.0,
  searchedFood: biriyani,
  otherItems: [friedRice, gheeRice],
 ),

];

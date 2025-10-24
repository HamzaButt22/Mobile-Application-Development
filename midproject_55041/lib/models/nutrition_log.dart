class NutritionLog {
  final String mealName;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime date;
  final String mealType;

  NutritionLog({
    required this.mealName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
    required this.mealType,
  });
}
class UserProfile {
  final String name;
  final int age;
  final double weight;
  final double height;
  final String goalType;
  final bool darkMode;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.goalType,
    required this.darkMode,
  });

  double get bmi => weight / ((height / 100) * (height / 100));
}
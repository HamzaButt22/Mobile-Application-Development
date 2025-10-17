// ============================================================================
// DATA MODELS AND CORE DART LOGIC
// ============================================================================

class UserProfile {
  String sex; // 'male' or 'female'
  double weight;
  String goal; // 'gain' or 'lose'

  UserProfile({
    required this.sex,
    required this.weight,
    required this.goal,
  });
}

class WorkoutLog {
  String exerciseName;
  int sets;
  int reps;
  double weightLifted;

  WorkoutLog({
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weightLifted,
  });
}

class FoodEntry {
  String dishName;
  double calories;
  double waterAmount;
  bool isSleepLog;
  double sleepDuration;

  FoodEntry({
    required this.dishName,
    required this.calories,
    this.waterAmount = 0,
    this.isSleepLog = false,
    this.sleepDuration = 0,
  });
}
import '../models/data_models.dart';

// ============================================================================
// HELPER FUNCTIONS AND UTILITY LOGIC
// ============================================================================

// CS Fundamentals: Personalized Routine Logic with if/else
String getRoutine(UserProfile user) {
  if (user.sex == 'male' && user.goal == 'gain') {
    return 'Beginner Bulk Program';
  } else if (user.sex == 'male' && user.goal == 'lose') {
    return 'Male Fat Loss Program';
  } else if (user.sex == 'female' && user.goal == 'gain') {
    return 'Female Strength Builder';
  } else {
    return 'Female Toning Program';
  }
}

// CS Fundamentals: Calculation Logic using loops
double calculateWeeklyVolume(List<WorkoutLog> workoutLogs) {
  double volume = 0;
  for (var log in workoutLogs) {
    volume += log.weightLifted * log.reps * log.sets;
  }
  return volume;
}

double calculateDailyCalories(List<FoodEntry> foodEntries) {
  double calories = 0;
  for (var entry in foodEntries) {
    if (!entry.isSleepLog) {
      calories += entry.calories;
    }
  }
  return calories;
}

double calculateTotalWater(List<FoodEntry> foodEntries) {
  double total = 0;
  for (var entry in foodEntries) {
    total += entry.waterAmount;
  }
  return total;
}

double calculateSleepScore(List<FoodEntry> foodEntries) {
  double totalSleep = 0;
  int sleepLogs = 0;
  for (var entry in foodEntries) {
    if (entry.isSleepLog) {
      totalSleep += entry.sleepDuration;
      sleepLogs++;
    }
  }
  return sleepLogs > 0 ? (totalSleep / sleepLogs) * 10 : 0;
}
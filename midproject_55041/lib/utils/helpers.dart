import 'package:flutter/material.dart';

class FitnessHelpers {
  // Business Logic - Volume Calculation
  static double calculateTotalVolume(List<dynamic> logs) {
    if (logs.isEmpty) return 0.0;
    return logs.fold(0.0, (sum, log) => sum + (log.totalVolume ?? 0.0));
  }

  // Business Logic - Calorie Calculation
  static int calculateTotalCalories(List<dynamic> logs) {
    if (logs.isEmpty) return 0;
    num total = logs.fold<num>(0, (sum, log) => sum + (log.calories ?? 0));
    return total.toInt();
  }

  // Business Logic - Average Calculation
  static double calculateAverage(List<dynamic> logs, double Function(dynamic) getValue) {
    if (logs.isEmpty) return 0.0;
    double sum = logs.fold(0.0, (sum, log) => sum + getValue(log));
    return sum / logs.length;
  }

  // Date Formatting
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // BMI Category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  // Color for BMI
  static Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}
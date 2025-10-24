import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../models/nutrition_log.dart';
import '../models/wellness_log.dart';
import '../models/user_profile.dart';
import '../utils/helpers.dart';

class DashboardScreen extends StatelessWidget {
  final List<WorkoutLog> workoutLogs;
  final List<NutritionLog> nutritionLogs;
  final List<WellnessLog> wellnessLogs;
  final UserProfile userProfile;

  const DashboardScreen({
    Key? key,
    required this.workoutLogs,
    required this.nutritionLogs,
    required this.wellnessLogs,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate metrics using Business Logic
    final totalVolume = FitnessHelpers.calculateTotalVolume(workoutLogs);
    final totalCalories = FitnessHelpers.calculateTotalCalories(nutritionLogs);
    final avgSleep = wellnessLogs.isEmpty ? 0.0 :
    FitnessHelpers.calculateAverage(wellnessLogs, (log) => log.sleepHours.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(context),
                const SizedBox(height: 20),
                _buildMetricsGrid(context, orientation, totalVolume, totalCalories, avgSleep),
                const SizedBox(height: 20),
                _buildQuickStats(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${userProfile.name}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Goal: ${userProfile.goalType}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip('BMI: ${userProfile.bmi.toStringAsFixed(1)}',
                  FitnessHelpers.getBMIColor(userProfile.bmi)),
              const SizedBox(width: 10),
              _buildStatChip(FitnessHelpers.getBMICategory(userProfile.bmi), Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == Colors.white ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, Orientation orientation,
      double totalVolume, int totalCalories, double avgSleep) {
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 4;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMetricCard(
          'Total Volume',
          '${totalVolume.toStringAsFixed(0)} kg',
          Icons.fitness_center,
          Colors.orange,
        ),
        _buildMetricCard(
          'Total Calories',
          '$totalCalories kcal',
          Icons.local_fire_department,
          Colors.red,
        ),
        _buildMetricCard(
          'Avg Sleep',
          '${avgSleep.toStringAsFixed(1)} hrs',
          Icons.bedtime,
          Colors.indigo,
        ),
        _buildMetricCard(
          'Total Logs',
          '${workoutLogs.length + nutritionLogs.length + wellnessLogs.length}',
          Icons.analytics,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          'Workouts Logged',
          workoutLogs.length.toString(),
          Icons.fitness_center,
          Colors.orange,
        ),
        _buildActivityTile(
          'Meals Tracked',
          nutritionLogs.length.toString(),
          Icons.restaurant,
          Colors.green,
        ),
        _buildActivityTile(
          'Wellness Entries',
          wellnessLogs.length.toString(),
          Icons.spa,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActivityTile(String title, String count, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

// ============================================================================
// DASHBOARD SCREEN WITH ADAPTIVE LAYOUT
// ============================================================================

class DashboardScreen extends StatelessWidget {
  final double currentCalories;
  final double calorieGoal;
  final double totalWater;
  final double waterGoal;
  final double sleepScore;
  final double weeklyVolume;
  final int streak;

  const DashboardScreen({
    Key? key,
    required this.currentCalories,
    required this.calorieGoal,
    required this.totalWater,
    required this.waterGoal,
    required this.sleepScore,
    required this.weeklyVolume,
    required this.streak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Implicit Animation 1: Progress Bar
            _buildAnimatedProgressBar(context),

            const SizedBox(height: 30),

            // Adaptive Grid Layout using OrientationBuilder
            OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;
                final crossAxisCount = isPortrait ? 2 : 5;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildMetricCard(context, index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressBar(BuildContext context) {
    final percentage = (currentCalories / calorieGoal).clamp(0.0, 1.0);
    final width = MediaQuery.of(context).size.width - 32;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calorie Goal: ${currentCalories.toInt()} / ${calorieGoal.toInt()} kcal',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: (width - 32) * percentage,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: percentage < 0.5
                          ? [Colors.orange[400]!, Colors.orange[600]!]
                          : percentage < 1.0
                          ? [Colors.blue[400]!, Colors.blue[600]!]
                          : [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Center(
                  child: Text(
                    '${(percentage * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, int index) {
    final metrics = [
      {'title': 'Calories In', 'value': '${currentCalories.toInt()}', 'icon': Icons.local_fire_department, 'color': Colors.orange},
      {'title': 'Water', 'value': '${totalWater.toInt()}ml', 'icon': Icons.water_drop, 'color': Colors.blue},
      {'title': 'Sleep Score', 'value': '${sleepScore.toInt()}', 'icon': Icons.nights_stay, 'color': Colors.purple},
      {'title': 'Volume', 'value': '${weeklyVolume.toInt()}kg', 'icon': Icons.fitness_center, 'color': Colors.red},
      {'title': 'Streak', 'value': '$streak days', 'icon': Icons.local_fire_department, 'color': Colors.deepOrange},
      {'title': 'Goal', 'value': '${calorieGoal.toInt()}', 'icon': Icons.flag, 'color': Colors.green},
    ];

    final metric = metrics[index];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (metric['color'] as Color).withOpacity(0.7),
            (metric['color'] as Color).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              metric['icon'] as IconData,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              metric['value'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              metric['title'] as String,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
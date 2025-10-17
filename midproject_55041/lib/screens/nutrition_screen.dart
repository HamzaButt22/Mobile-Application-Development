import 'package:flutter/material.dart';
import '../models/data_models.dart';

// ============================================================================
// NUTRITION SCREEN
// ============================================================================

class NutritionScreen extends StatefulWidget {
  final List<FoodEntry> foodEntries;
  final Function(FoodEntry) onAddEntry;
  final double currentCalories;

  const NutritionScreen({
    Key? key,
    required this.foodEntries,
    required this.onAddEntry,
    required this.currentCalories,
  }) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _dishController = TextEditingController();
  final _caloriesController = TextEditingController();
  bool _showSuccess = false;

  @override
  void dispose() {
    _dishController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _logFood() {
    if (_dishController.text.isEmpty) return;

    final entry = FoodEntry(
      dishName: _dishController.text,
      calories: double.tryParse(_caloriesController.text) ?? 0,
    );

    widget.onAddEntry(entry);

    setState(() {
      _showSuccess = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    });

    _dishController.clear();
    _caloriesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Implicit Animation: AnimatedOpacity for success feedback
            AnimatedOpacity(
              opacity: _showSuccess ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Success! Meal logged'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildFoodForm(),

            const SizedBox(height: 30),

            Text(
              'Today\'s Meals (${widget.currentCalories.toInt()} kcal)',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildFoodList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodForm() {
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
          const Text(
            'Log New Meal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dishController,
            decoration: const InputDecoration(
              labelText: 'Dish Name',
              hintText: 'e.g., Chicken Salad',
              prefixIcon: Icon(Icons.restaurant),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Calories',
              hintText: '450',
              prefixIcon: Icon(Icons.local_fire_department),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _logFood,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Log Food'),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  _dishController.clear();
                  _caloriesController.clear();
                },
                child: const Text('Clear Form'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    final foodItems = widget.foodEntries.where((e) => !e.isSleepLog).toList();

    if (foodItems.isEmpty) {
      return const Center(
        child: Text('No meals logged yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        final entry = foodItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.restaurant, color: Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.dishName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${entry.calories.toInt()} kcal',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
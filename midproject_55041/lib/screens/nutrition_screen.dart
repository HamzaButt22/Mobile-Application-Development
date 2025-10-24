import 'package:flutter/material.dart';
import '../models/nutrition_log.dart';
import '../utils/helpers.dart';

class NutritionScreen extends StatefulWidget {
  final List<NutritionLog> nutritionLogs;
  final Function(NutritionLog) onAddLog;
  final Function(int) onDeleteLog;

  const NutritionScreen({
    Key? key,
    required this.nutritionLogs,
    required this.onAddLog,
    required this.onDeleteLog,
  }) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final _mealNameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  String _selectedMealType = 'Breakfast';
  bool _showForm = false;
  bool _showSuccessMessage = false;

  @override
  void dispose() {
    _mealNameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  void _submitMeal() {
    if (_mealNameController.text.isEmpty ||
        _caloriesController.text.isEmpty ||
        _proteinController.text.isEmpty ||
        _carbsController.text.isEmpty ||
        _fatsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final log = NutritionLog(
      mealName: _mealNameController.text,
      calories: int.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbs: double.parse(_carbsController.text),
      fats: double.parse(_fatsController.text),
      date: DateTime.now(),
      mealType: _selectedMealType,
    );

    widget.onAddLog(log);
    _clearForm();

    setState(() {
      _showSuccessMessage = true;
      _showForm = false;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSuccessMessage = false;
        });
      }
    });
  }

  void _clearForm() {
    _mealNameController.clear();
    _caloriesController.clear();
    _proteinController.clear();
    _carbsController.clear();
    _fatsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = FitnessHelpers.calculateTotalCalories(widget.nutritionLogs);
    final dailyGoal = 2000;
    final progress = (totalCalories / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _showForm = !_showForm;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalorieProgressCard(totalCalories, dailyGoal, progress),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _buildNutritionForm(),
            crossFadeState: _showForm
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          AnimatedOpacity(
            opacity: _showSuccessMessage ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Text('Meal logged successfully!'),
                ],
              ),
            ),
          ),
          Expanded(child: _buildNutritionList()),
        ],
      ),
    );
  }

  Widget _buildCalorieProgressCard(int totalCalories, int dailyGoal, double progress) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calories Today',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalCalories / $dailyGoal kcal',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // AnimatedContainer - Implicit Animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% of daily goal',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _mealNameController,
            decoration: const InputDecoration(
              labelText: 'Meal Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedMealType,
            decoration: const InputDecoration(
              labelText: 'Meal Type',
              border: OutlineInputBorder(),
            ),
            items: ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedMealType = value!;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Calories',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _proteinController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Protein (g)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _carbsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Carbs (g)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _fatsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Fats (g)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitMeal,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
            ),
            child: const Text('Log Meal', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionList() {
    if (widget.nutritionLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No meals logged yet',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add your first meal',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.nutritionLogs.length,
      itemBuilder: (context, index) {
        final log = widget.nutritionLogs[widget.nutritionLogs.length - 1 - index];
        final actualIndex = widget.nutritionLogs.length - 1 - index;

        return Dismissible(
          key: Key('nutrition_$actualIndex'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => widget.onDeleteLog(actualIndex),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        log.mealType,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      FitnessHelpers.formatDate(log.date),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  log.mealName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroColumn('${log.calories}', 'Calories', Colors.red),
                      _buildMacroColumn('${log.protein}g', 'Protein', Colors.blue),
                      _buildMacroColumn('${log.carbs}g', 'Carbs', Colors.orange),
                      _buildMacroColumn('${log.fats}g', 'Fats', Colors.purple),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMacroColumn(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
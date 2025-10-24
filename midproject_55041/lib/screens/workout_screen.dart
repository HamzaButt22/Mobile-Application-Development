import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../utils/helpers.dart';

class WorkoutScreen extends StatefulWidget {
  final List<WorkoutLog> workoutLogs;
  final Function(WorkoutLog) onAddLog;
  final Function(int) onDeleteLog;

  const WorkoutScreen({
    Key? key,
    required this.workoutLogs,
    required this.onAddLog,
    required this.onDeleteLog,
  }) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with TickerProviderStateMixin {
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedCategory = 'Strength';
  bool _showSuccessMessage = false;
  bool _showForm = false;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    // Explicit Animation Setup
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _submitWorkout() {
    if (_exerciseController.text.isEmpty ||
        _setsController.text.isEmpty ||
        _repsController.text.isEmpty ||
        _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final log = WorkoutLog(
      exercise: _exerciseController.text,
      sets: int.parse(_setsController.text),
      reps: int.parse(_repsController.text),
      weight: double.parse(_weightController.text),
      date: DateTime.now(),
      category: _selectedCategory,
    );

    widget.onAddLog(log);
    _clearForm();

    // Trigger animations
    _progressController.forward(from: 0.0);
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
    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final totalVolume = FitnessHelpers.calculateTotalVolume(widget.workoutLogs);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
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
          _buildVolumeProgressCard(totalVolume),
          // AnimatedCrossFade - Implicit Animation
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _buildWorkoutForm(),
            crossFadeState: _showForm
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          // AnimatedOpacity - Implicit Animation
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
                  Text('Workout logged successfully!'),
                ],
              ),
            ),
          ),
          Expanded(child: _buildWorkoutList()),
        ],
      ),
    );
  }

  Widget _buildVolumeProgressCard(double totalVolume) {
    final goal = 50000.0;
    final progress = (totalVolume / goal).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Volume Lifted',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${totalVolume.toStringAsFixed(0)} kg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // AnimatedBuilder - Explicit Animation with AnimationController
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress * _progressAnimation.value,
                      minHeight: 8,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Goal: ${goal.toStringAsFixed(0)} kg',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutForm() {
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
            controller: _exerciseController,
            decoration: const InputDecoration(
              labelText: 'Exercise Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sets',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: ['Strength', 'Cardio', 'Flexibility', 'Sports']
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitWorkout,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.orange,
            ),
            child: const Text('Log Workout', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    if (widget.workoutLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No workouts logged yet',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add your first workout',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.workoutLogs.length,
      itemBuilder: (context, index) {
        final log = widget.workoutLogs[widget.workoutLogs.length - 1 - index];
        final actualIndex = widget.workoutLogs.length - 1 - index;

        return Dismissible(
          key: Key('workout_$actualIndex'),
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
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
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
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        log.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
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
                  log.exercise,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatBadge('${log.sets} sets', Icons.repeat),
                    const SizedBox(width: 12),
                    _buildStatBadge('${log.reps} reps', Icons.fitness_center),
                    const SizedBox(width: 12),
                    _buildStatBadge('${log.weight} kg', Icons.monitor_weight),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.analytics, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Volume: ${log.totalVolume.toStringAsFixed(0)} kg',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
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

  Widget _buildStatBadge(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }
}
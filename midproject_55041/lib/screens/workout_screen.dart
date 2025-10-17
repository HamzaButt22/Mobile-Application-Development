import 'package:flutter/material.dart';
import '../models/data_models.dart';

// ============================================================================
// WORKOUT LOG SCREEN
// ============================================================================

class WorkoutLogScreen extends StatefulWidget {
  final List<WorkoutLog> workoutLogs;
  final String currentRoutine;
  final Function(WorkoutLog) onAddLog;

  const WorkoutLogScreen({
    Key? key,
    required this.workoutLogs,
    required this.currentRoutine,
    required this.onAddLog,
  }) : super(key: key);

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _exerciseController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  bool _showRecommended = true;

  @override
  void dispose() {
    _exerciseController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _logWorkout() {
    if (_exerciseController.text.isEmpty) return;

    final log = WorkoutLog(
      exerciseName: _exerciseController.text,
      sets: int.tryParse(_setsController.text) ?? 0,
      reps: int.tryParse(_repsController.text) ?? 0,
      weightLifted: double.tryParse(_weightController.text) ?? 0,
    );

    widget.onAddLog(log);

    _exerciseController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout logged successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Workout Tracker',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showRecommended = !_showRecommended;
                    });
                  },
                  child: Text(_showRecommended ? 'Custom' : 'Recommended'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Implicit Animation: AnimatedCrossFade
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              firstChild: _buildRecommendedPlan(),
              secondChild: _buildCustomMessage(),
              crossFadeState: _showRecommended
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),

            const SizedBox(height: 30),

            _buildLogForm(),

            const SizedBox(height: 30),

            const Text(
              'Today\'s Session',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildWorkoutList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedPlan() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended: ${widget.currentRoutine}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('• Bench Press: 4x10'),
          const Text('• Squats: 4x8'),
          const Text('• Deadlifts: 3x6'),
          const Text('• Shoulder Press: 3x12'),
        ],
      ),
    );
  }

  Widget _buildCustomMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Plan Active',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('You are following your personalized workout routine.'),
        ],
      ),
    );
  }

  Widget _buildLogForm() {
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
            'Log New Exercise',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _exerciseController,
            decoration: const InputDecoration(
              labelText: 'Exercise Name',
              hintText: 'e.g., Bench Press',
              prefixIcon: Icon(Icons.fitness_center),
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
                    hintText: '4',
                    prefixIcon: Icon(Icons.format_list_numbered),
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
                    hintText: '10',
                    prefixIcon: Icon(Icons.repeat),
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
              hintText: '60',
              prefixIcon: Icon(Icons.monitor_weight),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _logWorkout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Log Exercise'),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  _exerciseController.clear();
                  _setsController.clear();
                  _repsController.clear();
                  _weightController.clear();
                },
                child: const Text('Clear Form'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList() {
    if (widget.workoutLogs.isEmpty) {
      return const Center(
        child: Text('No workouts logged yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.workoutLogs.length,
      itemBuilder: (context, index) {
        final log = widget.workoutLogs[index];
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
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.fitness_center, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.exerciseName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${log.sets} sets × ${log.reps} reps',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${log.weightLifted}kg',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
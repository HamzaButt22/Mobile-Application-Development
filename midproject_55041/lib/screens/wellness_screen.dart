import 'package:flutter/material.dart';
import '../models/wellness_log.dart';
import '../utils/helpers.dart';

class WellnessScreen extends StatefulWidget {
  final List<WellnessLog> wellnessLogs;
  final Function(WellnessLog) onAddLog;
  final Function(int) onDeleteLog;

  const WellnessScreen({
    Key? key,
    required this.wellnessLogs,
    required this.onAddLog,
    required this.onDeleteLog,
  }) : super(key: key);

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final _sleepController = TextEditingController();
  final _waterController = TextEditingController();
  int _stressLevel = 5;
  String _selectedMood = 'Neutral';
  bool _showForm = false;
  bool _showSuccessMessage = false;

  @override
  void dispose() {
    _sleepController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  void _submitWellness() {
    if (_sleepController.text.isEmpty || _waterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final log = WellnessLog(
      sleepHours: int.parse(_sleepController.text),
      waterIntake: int.parse(_waterController.text),
      stressLevel: _stressLevel,
      mood: _selectedMood,
      date: DateTime.now(),
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
    _sleepController.clear();
    _waterController.clear();
    setState(() {
      _stressLevel = 5;
      _selectedMood = 'Neutral';
    });
  }

  @override
  Widget build(BuildContext context) {
    final avgSleep = widget.wellnessLogs.isEmpty ? 0.0 :
    FitnessHelpers.calculateAverage(widget.wellnessLogs, (log) => log.sleepHours.toDouble());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Tracker'),
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
          _buildWellnessOverviewCard(avgSleep),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _buildWellnessForm(),
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
                  Text('Wellness entry logged successfully!'),
                ],
              ),
            ),
          ),
          Expanded(child: _buildWellnessList()),
        ],
      ),
    );
  }

  Widget _buildWellnessOverviewCard(double avgSleep) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.indigo.shade600],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Average Sleep',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${avgSleep.toStringAsFixed(1)} hours',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.bedtime, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'Target: 7-9 hours',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessForm() {
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
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sleepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sleep Hours',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _waterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Water (glasses)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Stress Level: $_stressLevel/10'),
          Slider(
            value: _stressLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: _stressLevel.toString(),
            onChanged: (value) {
              setState(() {
                _stressLevel = value.toInt();
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedMood,
            decoration: const InputDecoration(
              labelText: 'Mood',
              border: OutlineInputBorder(),
            ),
            items: ['Happy', 'Neutral', 'Sad', 'Stressed', 'Energetic', 'Tired']
                .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedMood = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitWellness,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.purple,
            ),
            child: const Text('Log Wellness', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildWellnessList() {
    if (widget.wellnessLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No wellness entries yet',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to add your first entry',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.wellnessLogs.length,
      itemBuilder: (context, index) {
        final log = widget.wellnessLogs[widget.wellnessLogs.length - 1 - index];
        final actualIndex = widget.wellnessLogs.length - 1 - index;

        return Dismissible(
          key: Key('wellness_$actualIndex'),
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
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
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
                        color: _getMoodColor(log.mood).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getMoodEmoji(log.mood),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            log.mood,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getMoodColor(log.mood),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      FitnessHelpers.formatDate(log.date),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildWellnessStat(
                        Icons.bedtime,
                        'Sleep',
                        '${log.sleepHours} hrs',
                        Colors.indigo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildWellnessStat(
                        Icons.water_drop,
                        'Water',
                        '${log.waterIntake} glasses',
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology, size: 20, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        'Stress Level: ${log.stressLevel}/10',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 100,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: log.stressLevel / 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getStressColor(log.stressLevel),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
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

  Widget _buildWellnessStat(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Happy':
        return Colors.green;
      case 'Energetic':
        return Colors.orange;
      case 'Neutral':
        return Colors.blue;
      case 'Tired':
        return Colors.indigo;
      case 'Stressed':
        return Colors.red;
      case 'Sad':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'Happy':
        return '😊';
      case 'Energetic':
        return '⚡';
      case 'Neutral':
        return '😐';
      case 'Tired':
        return '😴';
      case 'Stressed':
        return '😰';
      case 'Sad':
        return '😢';
      default:
        return '🙂';
    }
  }

  Color _getStressColor(int level) {
    if (level <= 3) return Colors.green;
    if (level <= 6) return Colors.orange;
    return Colors.red;
  }
}
import 'package:flutter/material.dart';

// ============================================================================
// WELLNESS SCREEN WITH EXPLICIT ANIMATION
// ============================================================================

class WellnessScreen extends StatefulWidget {
  final double totalWater;
  final double waterGoal;
  final double sleepScore;
  final Function(double) onAddWater;

  const WellnessScreen({
    Key? key,
    required this.totalWater,
    required this.waterGoal,
    required this.sleepScore,
    required this.onAddWater,
  }) : super(key: key);

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen>
    with TickerProviderStateMixin {
  final _waterController = TextEditingController();
  bool _showSuccess = false;

  // Explicit Animation: AnimationController, Tween, and AnimatedBuilder
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Explicit Animation Setup
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _waterController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _logWater() {
    final amount = double.tryParse(_waterController.text) ?? 0;
    if (amount > 0) {
      widget.onAddWater(amount);

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

      _waterController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoalReached = widget.totalWater >= widget.waterGoal;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wellness Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Explicit Animation: Floating Goal Icon
            if (isGoalReached)
              Center(
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 48,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Goal Reached!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            // Implicit Animation: Success feedback with AnimatedOpacity
            AnimatedOpacity(
              opacity: _showSuccess ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Success! Water added'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildWaterTracker(),

            const SizedBox(height: 20),

            _buildSleepTracker(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterTracker() {
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
          Row(
            children: [
              const Icon(Icons.water_drop, color: Colors.blue, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Hydration',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.totalWater.toInt()} / ${widget.waterGoal.toInt()} ml',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (widget.totalWater / widget.waterGoal).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _waterController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Add Water (ml)',
              hintText: '250',
              prefixIcon: Icon(Icons.local_drink),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _logWater,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Log Water'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _waterController.text = '250';
                  _logWater();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: const Text('+250ml'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTracker() {
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
          Row(
            children: [
              const Icon(Icons.nights_stay, color: Colors.purple, size: 28),
              const SizedBox(width: 8),
              const Text(
                'Sleep Quality',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Sleep Score: ${widget.sleepScore.toInt()}/100',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (widget.sleepScore / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            minHeight: 8,
          ),
          const SizedBox(height: 12),
          Text(
            widget.sleepScore >= 70
                ? '✓ Excellent sleep quality!'
                : 'Try to get 7-8 hours of sleep',
            style: TextStyle(
              color: widget.sleepScore >= 70 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
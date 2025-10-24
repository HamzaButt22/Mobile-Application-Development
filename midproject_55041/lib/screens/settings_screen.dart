import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/helpers.dart';

class SettingsScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(UserProfile) onUpdateProfile;

  const SettingsScreen({
    Key? key,
    required this.userProfile,
    required this.onUpdateProfile,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  late String _selectedGoal;
  bool _showEditForm = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userProfile.name;
    _ageController.text = widget.userProfile.age.toString();
    _weightController.text = widget.userProfile.weight.toString();
    _heightController.text = widget.userProfile.height.toString();
    _selectedGoal = widget.userProfile.goalType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final updatedProfile = UserProfile(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      goalType: _selectedGoal,
      darkMode: widget.userProfile.darkMode,
    );

    widget.onUpdateProfile(updatedProfile);

    setState(() {
      _showEditForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(_showEditForm ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _showEditForm = !_showEditForm;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: _buildEditForm(),
              crossFadeState: _showEditForm
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            const SizedBox(height: 20),
            _buildHealthMetrics(),
            const SizedBox(height: 20),
            _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.cyan.shade600],
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
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              widget.userProfile.name.isNotEmpty
                  ? widget.userProfile.name[0].toUpperCase()
                  : 'U',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.userProfile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.userProfile.goalType,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Container(
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
          const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedGoal,
            decoration: const InputDecoration(
              labelText: 'Fitness Goal',
              border: OutlineInputBorder(),
            ),
            items: ['Weight Loss', 'Muscle Gain', 'Maintenance', 'General Fitness']
                .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedGoal = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _updateProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.blue,
            ),
            child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics() {
    final bmi = widget.userProfile.bmi;
    final bmiCategory = FitnessHelpers.getBMICategory(bmi);
    final bmiColor = FitnessHelpers.getBMIColor(bmi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Health Metrics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bmiColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.monitor_weight, color: bmiColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Body Mass Index (BMI)',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bmi.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: bmiColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: bmiColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            bmiCategory,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: bmiColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricItem(
                    'Age',
                    '${widget.userProfile.age}',
                    Icons.cake,
                    Colors.pink,
                  ),
                  _buildMetricItem(
                    'Weight',
                    '${widget.userProfile.weight} kg',
                    Icons.fitness_center,
                    Colors.orange,
                  ),
                  _buildMetricItem(
                    'Height',
                    '${widget.userProfile.height} cm',
                    Icons.height,
                    Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
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
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSettingsTile(
          'Notifications',
          'Receive workout reminders',
          Icons.notifications,
          Colors.blue,
          true,
        ),
        _buildSettingsTile(
          'Privacy',
          'Manage your data',
          Icons.privacy_tip,
          Colors.orange,
          false,
        ),
        _buildSettingsTile(
          'About',
          'App version and info',
          Icons.info,
          Colors.green,
          false,
        ),
        _buildSettingsTile(
          'Help & Support',
          'Get assistance',
          Icons.help,
          Colors.purple,
          false,
        ),
      ],
    );
  }

  Widget _buildSettingsTile(String title, String subtitle, IconData icon,
      Color color, bool hasSwitch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: hasSwitch
            ? Switch(
          value: true,
          onChanged: (value) {},
        )
            : const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
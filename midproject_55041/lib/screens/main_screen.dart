import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../models/nutrition_log.dart';
import '../models/wellness_log.dart';
import '../models/user_profile.dart';
import 'dashboard_screen.dart';
import 'workout_screen.dart';
import 'nutrition_screen.dart';
import 'wellness_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // ========== STATE MANAGEMENT HUB - All App Data ==========
  final List<WorkoutLog> _workoutLogs = [];
  final List<NutritionLog> _nutritionLogs = [];
  final List<WellnessLog> _wellnessLogs = [];

  UserProfile _userProfile = UserProfile(
    name: 'Fitness Enthusiast',
    age: 25,
    weight: 70.0,
    height: 170.0,
    goalType: 'Weight Loss',
    darkMode: false,
  );

  // ========== CALLBACK FUNCTIONS - State Update Handlers ==========
  void _addWorkoutLog(WorkoutLog log) {
    setState(() {
      _workoutLogs.add(log);
    });
  }

  void _addNutritionLog(NutritionLog log) {
    setState(() {
      _nutritionLogs.add(log);
    });
  }

  void _addWellnessLog(WellnessLog log) {
    setState(() {
      _wellnessLogs.add(log);
    });
  }

  void _updateUserProfile(UserProfile profile) {
    setState(() {
      _userProfile = profile;
    });
  }

  void _deleteWorkoutLog(int index) {
    setState(() {
      _workoutLogs.removeAt(index);
    });
  }

  void _deleteNutritionLog(int index) {
    setState(() {
      _nutritionLogs.removeAt(index);
    });
  }

  void _deleteWellnessLog(int index) {
    setState(() {
      _wellnessLogs.removeAt(index);
    });
  }

  List<Widget> _getScreens() {
    return [
      DashboardScreen(
        workoutLogs: _workoutLogs,
        nutritionLogs: _nutritionLogs,
        wellnessLogs: _wellnessLogs,
        userProfile: _userProfile,
      ),
      WorkoutScreen(
        workoutLogs: _workoutLogs,
        onAddLog: _addWorkoutLog,
        onDeleteLog: _deleteWorkoutLog,
      ),
      NutritionScreen(
        nutritionLogs: _nutritionLogs,
        onAddLog: _addNutritionLog,
        onDeleteLog: _deleteNutritionLog,
      ),
      WellnessScreen(
        wellnessLogs: _wellnessLogs,
        onAddLog: _addWellnessLog,
        onDeleteLog: _deleteWellnessLog,
      ),
      SettingsScreen(
        userProfile: _userProfile,
        onUpdateProfile: _updateUserProfile,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _getScreens(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa),
            label: 'Wellness',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
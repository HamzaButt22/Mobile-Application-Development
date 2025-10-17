import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../utils/helpers.dart';
import 'dashboard_screen.dart';
import 'workout_screen.dart';
import 'nutrition_screen.dart';
import 'wellness_screen.dart';
import 'settings_screen.dart';

// ============================================================================
// MAIN SCREEN WITH STATE MANAGEMENT
// ============================================================================

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // State Management: Global data lists and variables
  List<WorkoutLog> workoutLogs = [];
  List<FoodEntry> foodEntries = [];
  double _currentCalorieIntake = 0;
  double _weeklyVolume = 0;
  String _currentRoutine = '';
  UserProfile userProfile = UserProfile(sex: 'male', weight: 75, goal: 'gain');

  // Additional state variables
  double dailyCalorieGoal = 2500;
  double dailyWaterGoal = 2000;
  int currentStreak = 7;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _calculateRoutine();
  }

  void _initializeData() {
    // Initialize with sample data
    workoutLogs = [
      WorkoutLog(exerciseName: 'Bench Press', sets: 4, reps: 10, weightLifted: 60),
      WorkoutLog(exerciseName: 'Squats', sets: 4, reps: 8, weightLifted: 80),
      WorkoutLog(exerciseName: 'Deadlifts', sets: 3, reps: 6, weightLifted: 100),
    ];

    foodEntries = [
      FoodEntry(dishName: 'Chicken Salad', calories: 450, waterAmount: 500),
      FoodEntry(dishName: 'Protein Shake', calories: 300, waterAmount: 350),
      FoodEntry(dishName: 'Evening Sleep', calories: 0, isSleepLog: true, sleepDuration: 7.5),
    ];

    _calculateMetrics();
  }

  void _calculateMetrics() {
    setState(() {
      _weeklyVolume = calculateWeeklyVolume(workoutLogs);
      _currentCalorieIntake = calculateDailyCalories(foodEntries);
    });
  }

  void _calculateRoutine() {
    String routine = getRoutine(userProfile);
    setState(() {
      _currentRoutine = routine;
    });
  }

  void _addWorkoutLog(WorkoutLog log) {
    setState(() {
      workoutLogs.add(log);
      _calculateMetrics();
    });
  }

  void _addFoodEntry(FoodEntry entry) {
    setState(() {
      foodEntries.add(entry);
      _calculateMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        currentCalories: _currentCalorieIntake,
        calorieGoal: dailyCalorieGoal,
        totalWater: calculateTotalWater(foodEntries),
        waterGoal: dailyWaterGoal,
        sleepScore: calculateSleepScore(foodEntries),
        weeklyVolume: _weeklyVolume,
        streak: currentStreak,
      ),
      WorkoutLogScreen(
        workoutLogs: workoutLogs,
        currentRoutine: _currentRoutine,
        onAddLog: _addWorkoutLog,
      ),
      NutritionScreen(
        foodEntries: foodEntries,
        onAddEntry: _addFoodEntry,
        currentCalories: _currentCalorieIntake,
      ),
      WellnessScreen(
        totalWater: calculateTotalWater(foodEntries),
        waterGoal: dailyWaterGoal,
        sleepScore: calculateSleepScore(foodEntries),
        onAddWater: (amount) {
          _addFoodEntry(FoodEntry(
            dishName: 'Water',
            calories: 0,
            waterAmount: amount,
          ));
        },
      ),
      SettingsScreen(userProfile: userProfile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive Fitness Hub'),
        elevation: 2,
      ),
      drawer: _buildDrawer(),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: 'Wellness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quick Add Feature')),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(height: 0),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[400]!],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Fitness Pro',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Data Backup/Export'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
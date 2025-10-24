class WorkoutLog {
  final String exercise;
  final int sets;
  final int reps;
  final double weight;
  final DateTime date;
  final String category;

  WorkoutLog({
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.date,
    required this.category,
  });

  double get totalVolume => sets * reps * weight;
}
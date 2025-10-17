void main() {
  //runApp(const MyApp());
  List<int> numbers = [1, 2, 3, 4, 5, 6];
  int smallest = numbers[0];
  int sum = 0;

  print("Enter 6 integers");

  for (int i = 0; i < 6; i++) {
    if (numbers[i] % 2 != 0) {
      sum = sum + numbers[i];
    }

    if (numbers[i] < smallest) {
      smallest = numbers[i];
    }
  }
  print('Sum Of Odd Numbers: $sum');
  print('Smallest Number: $smallest');
}

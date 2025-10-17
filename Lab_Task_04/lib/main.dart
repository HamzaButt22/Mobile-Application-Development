import 'dart:math';

void main() {
  //runApp(const MyApp());
  Circle c = Circle(5);
  print("Area Of Circle: ${c.CalculateArea()}");
  print("Circumference Of Circle: ${c.CalculateCircumference()}");
}

class Shape {
  Shape() {
    print('Shape Constructor Called');
  }

  double CalculateArea() {
    return 0;
  }

  double CalculateCircumference() {
    return 0;
  }
}

class Circle extends Shape {
  double radius;

  Circle(this.radius) : super();

  @override
  double CalculateArea() {
    return pi * radius * radius;
  }

  @override
  double CalculateCircumference() {
    return 2 * pi * radius;
  }
}

import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(const TravelExplorerApp());
}

class TravelExplorerApp extends StatelessWidget {
  const TravelExplorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Explorer - Chapter 9 Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
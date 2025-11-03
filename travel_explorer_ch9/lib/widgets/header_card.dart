import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Discover Amazing Places', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8.0),
            Text('Explore world\'s most beautiful destinations', style: TextStyle(fontSize: 16.0, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
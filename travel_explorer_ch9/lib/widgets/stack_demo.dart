import 'package:flutter/material.dart';
import 'classes/destination.dart';
import 'stack_card.dart';

class StackDemo extends StatelessWidget {
const StackDemo({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
return ListView.builder(
padding: const EdgeInsets.all(16.0),
itemCount: Destination.destinations.length,
itemBuilder: (context, index) => StackCard(destination: Destination.destinations[index]),
);
}
}
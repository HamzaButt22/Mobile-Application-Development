import 'package:flutter/material.dart';
import 'classes/destination.dart';

class DestinationListItem extends StatelessWidget {
  final Destination destination;

  const DestinationListItem({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.indigo.shade100,
          child: Text(destination.emoji, style: const TextStyle(fontSize: 28.0)),
        ),
        title: Text(destination.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        subtitle: Text(destination.country, style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18.0),
                const SizedBox(width: 4.0),
                Text('${destination.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),
            const SizedBox(height: 4.0),
            Text(destination.visitors, style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
          ],
        ),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on ${destination.name}')),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'classes/destination.dart';

class StackCard extends StatelessWidget {
  final Destination destination;

  const StackCard({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: SizedBox(
          height: 220.0,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade400, Colors.purple.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20.0,
                left: 20.0,
                child: Text(destination.emoji, style: const TextStyle(fontSize: 64.0)),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: Row(
                  children: const [
                    CircleAvatar(radius: 18, backgroundColor: Colors.white30, child: Icon(Icons.share, color: Colors.white, size: 18)),
                    SizedBox(width: 8.0),
                    CircleAvatar(radius: 18, backgroundColor: Colors.white30, child: Icon(Icons.bookmark_border, color: Colors.white, size: 18)),
                  ],
                ),
              ),
              Positioned(
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination.name, style: const TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Chip(
                          avatar: const Icon(Icons.location_on, color: Colors.white, size: 16.0),
                          label: Text(destination.country, style: const TextStyle(color: Colors.white, fontSize: 14.0)),
                          backgroundColor: Colors.white30,
                        ),
                        const SizedBox(width: 8.0),
                        Chip(
                          avatar: const Icon(Icons.star, color: Colors.amber, size: 16.0),
                          label: Text('${destination.rating}', style: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.white30,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.people, color: Colors.white70, size: 18.0),
                        const SizedBox(width: 6.0),
                        Text('${destination.visitors} annual visitors', style: const TextStyle(color: Colors.white70, fontSize: 14.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
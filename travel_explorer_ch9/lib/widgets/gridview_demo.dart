import 'package:flutter/material.dart';
import 'classes/destination.dart';
import 'grid_card.dart';

class GridViewDemo extends StatefulWidget {
  const GridViewDemo({Key? key}) : super(key: key);

  @override
  State<GridViewDemo> createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  final Set<int> _favorites = {};

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.85,
      ),
      itemCount: Destination.destinations.length,
      itemBuilder: (context, index) {
        final dest = Destination.destinations[index];
        return GridCard(
          destination: dest,
          isFavorite: _favorites.contains(dest.id),
          onFavoriteTap: () => setState(() {
            _favorites.contains(dest.id) ? _favorites.remove(dest.id) : _favorites.add(dest.id);
          }),
        );
      },
    );
  }
}
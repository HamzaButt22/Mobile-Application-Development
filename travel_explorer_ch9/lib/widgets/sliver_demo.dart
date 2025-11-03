import 'package:flutter/material.dart';
import 'classes/destination.dart';

class SliverDemo extends StatelessWidget {
  const SliverDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Explore World', style: TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black45, blurRadius: 4.0)])),
            centerTitle: true,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.purple], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: const Center(child: Text('✈️', style: TextStyle(fontSize: 80.0))),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8.0),
                Text('Featured Destinations', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final dest = Destination.destinations[index];
              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.indigo.shade200,
                    child: Text(dest.emoji, style: const TextStyle(fontSize: 28.0)),
                  ),
                  title: Text('${dest.name}, ${dest.country}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  subtitle: Text('Rating: ${dest.rating} ⭐ | ${dest.visitors} visitors', style: const TextStyle(fontSize: 12.0)),
                ),
              );
            },
            childCount: 3,
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.explore, color: Colors.green),
                SizedBox(width: 8.0),
                Text('More Destinations', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.9,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final dest = Destination.destinations[index + 3];
                return Card(
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Colors.teal, Colors.cyan]),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                          ),
                          child: Center(child: Text(dest.emoji, style: const TextStyle(fontSize: 40.0))),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dest.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('⭐ ${dest.rating}', style: const TextStyle(fontSize: 12.0)),
                                  Text(dest.visitors, style: const TextStyle(fontSize: 10.0, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: Destination.destinations.length - 3,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
      ],
    );
  }
}
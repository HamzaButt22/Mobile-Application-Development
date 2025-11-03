import 'package:flutter/material.dart';
import 'package:travel_explorer_ch9/classes/destination.dart';
import 'header_card.dart';
import 'destination_list_item.dart';

class ListViewDemo extends StatelessWidget {
  const ListViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: Destination.destinations.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const HeaderCard();
        return DestinationListItem(destination: Destination.destinations[index - 1]);
      },
    );
  }
}
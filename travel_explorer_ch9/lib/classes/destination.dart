class Destination {
  final int id;
  final String name;
  final String country;
  final double rating;
  final String visitors;
  final String emoji;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.rating,
    required this.visitors,
    required this.emoji,
  });

  static const List<Destination> destinations = [
    Destination(id: 1, name: 'Paris', country: 'France', rating: 4.8, visitors: '2M+', emoji: '🗼'),
    Destination(id: 2, name: 'Tokyo', country: 'Japan', rating: 4.9, visitors: '3M+', emoji: '🗾'),
    Destination(id: 3, name: 'New York', country: 'USA', rating: 4.7, visitors: '5M+', emoji: '🗽'),
    Destination(id: 4, name: 'London', country: 'UK', rating: 4.6, visitors: '4M+', emoji: '🏰'),
    Destination(id: 5, name: 'Dubai', country: 'UAE', rating: 4.8, visitors: '2.5M+', emoji: '🕌'),
    Destination(id: 6, name: 'Sydney', country: 'Australia', rating: 4.7, visitors: '1.5M+', emoji: '🏖️'),
    Destination(id: 7, name: 'Rome', country: 'Italy', rating: 4.9, visitors: '3.5M+', emoji: '🏛️'),
    Destination(id: 8, name: 'Barcelona', country: 'Spain', rating: 4.6, visitors: '2M+', emoji: '⛱️'),
    Destination(id: 9, name: 'Singapore', country: 'Singapore', rating: 4.8, visitors: '1.8M+', emoji: '🌆'),
    Destination(id: 10, name: 'Bangkok', country: 'Thailand', rating: 4.5, visitors: '2.2M+', emoji: '🛕'),
  ];
}
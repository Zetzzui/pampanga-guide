/// Static mock data for the UI-first pass.
/// Firestore will replace this in a later step.
class Place {
  const Place({
    required this.name,
    required this.city,
    required this.tags,
    required this.description,
    required this.phrase,
    required this.pronunciation,
    required this.meaning,
  });

  final String name;
  final String city;
  final List<String> tags;
  final String description;
  final String phrase;
  final String pronunciation;
  final String meaning;
}

const mockPlaces = [
  Place(
    name: 'Aling Lucing',
    city: 'Angeles City',
    tags: ['Sisig', 'Local favorite'],
    description:
        "A well-known stop for Pampanga's signature sizzling dish. "
        'Explore the area, then try a phrase at the table.',
    phrase: 'Manyaman!',
    pronunciation: 'mah-nya-MAH-nan',
    meaning: 'Delicious',
  ),
  Place(
    name: "Everybody's Café",
    city: 'City of San Fernando',
    tags: ['Kapampangan', 'Heritage'],
    description: 'A family-run landmark serving classic Kapampangan dishes.',
    phrase: 'Manyaman!',
    pronunciation: 'mah-nya-MAH-nan',
    meaning: 'Delicious',
  ),
];

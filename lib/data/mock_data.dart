/// Data models plus sample data.
///
/// The sample data is shown when Firebase is not set up yet (guest mode),
/// so the app still works before the Firestore project is connected.
class Phrase {
  const Phrase({
    required this.category,
    required this.kapampangan,
    required this.english,
    this.syllables = '',
    this.note = '',
  });

  final String category;
  final String kapampangan;
  final String english;
  final String syllables;
  final String note;

  /// Builds a phrase from a Firestore map. Missing fields become ''.
  factory Phrase.fromMap(Map<String, dynamic> data) {
    return Phrase(
      category: data['category'] as String? ?? '',
      kapampangan: data['kapampangan'] as String? ?? '',
      english: data['english'] as String? ?? '',
      syllables: data['syllables'] as String? ?? '',
      note: data['note'] as String? ?? '',
    );
  }
}

// TODO: verify every phrase with a Kapampangan speaker before release.
const mockPhrases = [
  Phrase(
    category: 'Food',
    kapampangan: 'Manyaman!',
    english: 'Delicious!',
    syllables: 'mah-nya-man',
    note:
        'Stress the final syllable. Say it after a delicious meal.',
  ),
  Phrase(
    category: 'Greetings',
    kapampangan: 'Kumusta ka?',
    english: 'How are you?',
    syllables: 'koo · moos · TAH kah',
    note: 'Ask someone how they are. Keep your tone warm and friendly.',
  ),
  Phrase(
    category: 'Greetings',
    kapampangan: 'Dakal a salamat.',
    english: 'Thank you very much.',
    syllables: 'dah · KAL ah sah · LAH · maht',
    note: 'A warm way to say thank you. Try it at the end of your meal.',
  ),
];

/// A tourist spot from the Firestore `spots` collection.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.tags,
    required this.phrase,
    required this.mapQuery,
    this.tagline = '',
  });

  /// Firestore document id. Used to save and look up a spot.
  final String id;
  final String name;
  final String city;
  final String tagline;
  final String description;
  final List<String> tags;
  final Phrase phrase;

  /// Text sent to Google Maps to find this spot, e.g. "Aling Lucing Angeles".
  final String mapQuery;

  /// Builds a place from a Firestore `spots` document.
  factory Place.fromMap(String id, Map<String, dynamic> data) {
    final phraseData = data['phrase'];
    return Place(
      id: id,
      name: data['name'] as String? ?? '',
      city: data['city'] as String? ?? '',
      tagline: data['tagline'] as String? ?? '',
      description: data['description'] as String? ?? '',
      tags: List<String>.from(data['tags'] as List? ?? const []),
      phrase: phraseData is Map<String, dynamic>
          ? Phrase.fromMap(phraseData)
          : const Phrase(category: '', kapampangan: '', english: ''),
      mapQuery: data['mapQuery'] as String? ?? '',
    );
  }

  /// True if the name, city, or a tag contains [query] (case-insensitive).
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        city.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }
}

// TODO: verify addresses, hours, and descriptions before release.
const mockPlaces = [
  Place(
    id: 'aling-lucing',
    name: 'Aling Lucing',
    city: 'Angeles City',
    tagline: 'The taste of sisig country.',
    description:
        "A well-known stop for Pampanga's signature sizzling dish. "
        'Explore the area, then try a phrase at the table.',
    tags: ['Sisig', 'Local favorite'],
    mapQuery: 'Aling Lucing Angeles City',
    phrase: Phrase(
      category: 'Food',
      kapampangan: 'Manyaman!',
      english: 'Delicious!',
      syllables: 'mah-nya-man',
      note: 'Stress the final syllable. Say it after a delicious meal.',
    ),
  ),
  Place(
    id: 'everybodys-cafe',
    name: "Everybody's Café",
    city: 'City of San Fernando',
    tagline: 'A table of Kapampangan heritage.',
    description:
        'Explore traditional Kapampangan cooking with a little local '
        'language at your meal.',
    tags: ['Kapampangan', 'Heritage'],
    mapQuery: "Everybody's Cafe City of San Fernando Pampanga",
    phrase: Phrase(
      category: 'Greetings',
      kapampangan: 'Dakal a salamat.',
      english: 'Thank you very much.',
      syllables: 'dah · KAL ah sah · LAH · maht',
      note: 'A warm way to say thank you. Try it at the end of your meal.',
    ),
  ),
];

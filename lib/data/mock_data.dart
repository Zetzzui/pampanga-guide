/// Static mock data for the UI-first pass.
/// Firestore will replace this in a later step.
class Phrase {
  const Phrase({
    required this.category,
    required this.kapampangan,
    required this.english,
    required this.syllables,
    required this.note,
  });

  final String category;
  final String kapampangan;
  final String english;
  final String syllables;
  final String note;
}

// TODO: verify every phrase with a Kapampangan speaker before release.
const mockPhrases = [
  Phrase(
    category: 'Food',
    kapampangan: 'Manyaman!',
    english: 'Delicious!',
    syllables: 'mah · nyah · MAHN',
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

class Place {
  const Place({
    required this.name,
    required this.city,
    required this.tagline,
    required this.description,
    required this.tags,
    required this.phrase,
  });

  final String name;
  final String city;
  final String tagline;
  final String description;
  final List<String> tags;
  final Phrase phrase;
}

// TODO: verify addresses, hours, and descriptions before release.
const mockPlaces = [
  Place(
    name: 'Aling Lucing',
    city: 'Angeles City',
    tagline: 'The taste of sisig country.',
    description:
        "A well-known stop for Pampanga's signature sizzling dish. "
        'Explore the area, then try a phrase at the table.',
    tags: ['Sisig', 'Local favorite'],
    phrase: Phrase(
      category: 'Food',
      kapampangan: 'Manyaman!',
      english: 'Delicious!',
      syllables: 'mah · nyah · MAHN',
      note: 'Stress the final syllable. Say it after a delicious meal.',
    ),
  ),
  Place(
    name: "Everybody's Café",
    city: 'City of San Fernando',
    tagline: 'A table of Kapampangan heritage.',
    description:
        'Explore traditional Kapampangan cooking with a little local '
        'language at your meal.',
    tags: ['Kapampangan', 'Heritage'],
    phrase: Phrase(
      category: 'Greetings',
      kapampangan: 'Dakal a salamat.',
      english: 'Thank you very much.',
      syllables: 'dah · KAL ah sah · LAH · maht',
      note: 'A warm way to say thank you. Try it at the end of your meal.',
    ),
  ),
];

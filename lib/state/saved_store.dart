import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';

/// In-memory saved places shared by Places, Place Details, and Saved.
/// TODO: replace with the user's saved spots in Firestore.
class SavedStore extends ChangeNotifier {
  SavedStore._();

  static final instance = SavedStore._();

  final Set<String> _names = {};

  bool isSaved(Place place) => _names.contains(place.name);

  List<Place> get places =>
      mockPlaces.where((place) => _names.contains(place.name)).toList();

  int get count => _names.length;

  void toggle(Place place) {
    if (!_names.remove(place.name)) {
      _names.add(place.name);
    }
    notifyListeners();
  }

  void remove(Place place) {
    if (_names.remove(place.name)) notifyListeners();
  }
}

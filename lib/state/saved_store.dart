import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';

/// In-memory saved places shared by Places, Place Details, and Saved.
/// Places are stored by their Firestore id.
/// TODO: replace with the user's saved spots in Firestore (Saved step).
class SavedStore extends ChangeNotifier {
  SavedStore._();

  static final instance = SavedStore._();

  final Map<String, Place> _saved = {};

  bool isSaved(Place place) => _saved.containsKey(place.id);

  List<Place> get places => _saved.values.toList();

  int get count => _saved.length;

  void toggle(Place place) {
    if (_saved.remove(place.id) == null) {
      _saved[place.id] = place;
    }
    notifyListeners();
  }

  void remove(Place place) {
    if (_saved.remove(place.id) != null) notifyListeners();
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/mock_data.dart';
import 'auth_service.dart';

/// What the Places screen gets back from [PlacesService.fetchPlaces].
class PlacesResult {
  const PlacesResult({
    required this.places,
    this.isOffline = false,
    this.isSample = false,
  });

  final List<Place> places;

  /// True when the list came from the phone's cache because there is no
  /// internet. The screen shows the Offline Banner.
  final bool isOffline;

  /// True when Firebase is not set up yet and sample data is shown.
  final bool isSample;
}

/// Thrown when the spots cannot be loaded. [message] is safe to show.
class PlacesException implements Exception {
  const PlacesException(this.message, {this.isOffline = false});

  final String message;

  /// True when the failure was caused by having no internet.
  final bool isOffline;
}

/// All Firestore calls for the `spots` collection live here, not in screens.
class PlacesService {
  PlacesService._();

  static final instance = PlacesService._();

  /// How long to wait for Firestore before giving up.
  static const _timeout = Duration(seconds: 10);

  CollectionReference<Map<String, dynamic>> get _spots =>
      FirebaseFirestore.instance.collection('spots');

  /// Loads every spot, sorted by name.
  ///
  /// Falls back to sample data when Firebase is not set up yet.
  Future<PlacesResult> fetchPlaces() async {
    if (!AuthService.instance.isReady) {
      return const PlacesResult(places: mockPlaces, isSample: true);
    }

    try {
      final snapshot = await _spots.orderBy('name').get().timeout(_timeout);
      final places = snapshot.docs
          .map((doc) => Place.fromMap(doc.id, doc.data()))
          .toList();
      return PlacesResult(
        places: places,
        // Firestore serves cached data when the phone is offline.
        isOffline: snapshot.metadata.isFromCache,
      );
    } on TimeoutException {
      throw const PlacesException(
        'No internet connection. Check your connection and try again.',
        isOffline: true,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const PlacesException(
          'No internet connection. Check your connection and try again.',
          isOffline: true,
        );
      }
      if (e.code == 'permission-denied') {
        throw const PlacesException(
          'You do not have access to these places. Please log in again.',
        );
      }
      throw const PlacesException('Could not load places. Please try again.');
    }
  }
}

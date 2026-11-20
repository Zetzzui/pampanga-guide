import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// The Firestore database ID made in the Firebase console.
///
/// The LOCALINGO database was created with the ID "default" (no brackets),
/// which is different from Firebase's built-in "(default)" database.
const firestoreDatabaseId = 'default';

/// The app's Firestore database. Every service uses this, not
/// `FirebaseFirestore.instance`, so they all reach the same database.
FirebaseFirestore get appFirestore => FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: firestoreDatabaseId,
    );

# LOCALINGO

A mobile app for a student research project. It recommends local places in Pampanga, Philippines, and teaches the Kapampangan language.

## Features

- Sign up and log in.
- Places: search, filter, and save restaurants and tourist spots.
- Learn: flashcards for Kapampangan words and phrases.
- Quiz: multiple choice questions with a score and streak.
- Saved: a list of your favorite places.

## Software

- Flutter: builds the mobile app and its user interface.
- Dart: the programming language for the features and functions.
- Firebase Firestore: stores tourist spots, Kapampangan words and phrases, and user information.
- Firebase Authentication: manages user accounts and secures login.

## Workflow

All user flows are in [workflow.md](workflow.md).

## Run the App

1. Install Flutter. Run `flutter doctor` and fix any issue it reports.
2. Clone the repository: `git clone https://github.com/Zetzzui/pampanga-guide.git`
3. Open the folder in VS Code.
4. Install packages: `flutter pub get`
5. Connect your Firebase project: `flutterfire configure`
6. Start the app: `flutter run`

## Firebase Setup

1. Create a project in the Firebase console.
2. Turn on Authentication with Email and Password.
3. Create a Firestore database.
4. Add the collections: spots, phrases, users.

## Project Structure

```
pampanga-guide/
  README.md
  AGENTS.md
  workflow.md
  lib/
  pubspec.yaml
```

## Data Notes

- Verify restaurant and spot details.
- Have a native speaker review each Kapampangan phrase.

## Author

Davenath Olazo, University of the East Manila.
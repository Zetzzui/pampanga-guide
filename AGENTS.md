# AI Instructions for LOCALINGO

## Project

A mobile app for a student research project. It recommends local places in Pampanga, Philippines, and teaches Kapampangan.

## Stack

- Flutter for the app and its user interface.
- Dart for all features and functions.
- Firebase Firestore for tourist spots, Kapampangan words and phrases, and user information.
- Firebase Authentication for accounts and login.
- Google Maps for the user's location and nearby place recommendations. Use geolocator for location and google_maps_flutter for maps.
- Figma holds the design. Match its layout, colors, and components.
- Canva assets (images and icons) go in the assets folder.

## Source of Truth

- Follow workflow.md for every user flow.
- Use the same screen names as workflow.md.
- Add Sign Up and Log In screens before Places.
- Do not add features beyond those listed.

## Screens

Splash, Onboarding, Sign Up, Log In, Location Permission, Places, Place Details, Learn, Flashcard, Quiz, Results, Saved.

## Rules

- Build one screen at a time. Wait for approval before the next one.
- Keep code simple and commented.
- Put Firestore calls in separate service files, not inside screens.
- Use one widget per component. Reuse widgets across screens.
- Handle loading, offline, empty, and error states on every screen.
- Touch targets are 48dp or larger.
- Meet WCAG AA contrast.
- Support light and dark themes.
- Never commit Firebase keys or secret files.

## Firestore Data

- spots: name, city, tags, description, Kapampangan phrase, map query.
- phrases: category, Kapampangan, English.
- users: uid, email, saved spots, quiz scores, streak.

## Accuracy

- Do not invent places, hours, or prices. Mark unverified data with a TODO.
- Do not invent Kapampangan words. Mark unverified phrases with a TODO.

## Before Each Commit

- Run `flutter analyze`. Fix every error.
- Run `flutter run`. Confirm the app starts.
- List the files changed.
- Write a short commit message.
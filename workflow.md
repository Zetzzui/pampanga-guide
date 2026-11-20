# Pampanga Guide Workflow

## 1. First Launch

```mermaid
flowchart TD
    A([Start]) --> B(Splash)
    B -->|"auto after 2s"| C(Onboarding 1)
    C -->|"swipe"| D(Onboarding 2)
    D -->|"swipe"| E(Onboarding 3)
    E -->|"tap Continue"| F(Location Permission)
    F --> G{Allow location?}
    G -->|"allow"| H(Places)
    G -->|"skip"| H
```

## 2. Find a Restaurant

```mermaid
flowchart TD
    A(Places) -->|"type in search or tap chip"| B{Results found?}
    B -->|"no"| C(No Results)
    C -->|"clear search"| A
    B -->|"yes"| D(Results List)
    D -->|"tap card"| E(Place Details)
    E --> F{User choice}
    F -->|"tap star"| G(Saved updated)
    F -->|"tap Directions"| H(Maps App)
    F -->|"tap back"| D
    G --> E
```

## 3. Learn a Phrase

```mermaid
flowchart TD
    A(Learn) -->|"pick category"| B(Flashcard Front)
    B -->|"tap card"| C(Flashcard Back)
    C -->|"tap speaker"| D(Audio Playing)
    D --> C
    C --> E{More cards?}
    E -->|"yes, tap Next"| B
    E -->|"no"| F(Category Complete)
    F -->|"pick another"| A
```

## 4. Take a Quiz

```mermaid
flowchart TD
    A(Quiz) -->|"start"| B(Question)
    B -->|"tap answer"| C{Correct?}
    C -->|"yes"| D(Green Feedback)
    C -->|"no"| E(Red Feedback)
    D --> F{Last question?}
    E --> F
    F -->|"no, tap Next"| B
    F -->|"yes"| G(Results and Streak)
    G --> H{User choice}
    H -->|"retry"| B
    H -->|"return"| I(Learn)
```

## 5. Save a Favorite

```mermaid
flowchart TD
    A(Place Card) -->|"tap star"| B(Star filled)
    B --> C(Saved list updated)
    C -->|"open Saved tab"| D{Any saved places?}
    D -->|"yes"| E(Saved List)
    D -->|"no"| F(Empty State)
    E -->|"tap star again"| G(Place removed)
    G --> D
    F -->|"tap Browse Places"| H(Places)
```

## 6. Error Paths

```mermaid
flowchart TD
    A([Error]) --> B{Error type}
    B -->|"no internet"| C(Offline Banner)
    C -->|"show saved and cached data"| D(Retry button)
    D -->|"tap Retry"| E{Connected?}
    E -->|"yes"| F(Reload screen)
    E -->|"no"| C
    B -->|"location denied"| G(Location Prompt)
    G -->|"tap Open Settings"| H(Device Settings)
    G -->|"tap Not now"| I(Places without distance)
    B -->|"no search results"| J(No Results)
    J -->|"tap Clear filters"| K(Places)
```

## Screen Map

| Screen | Next screens |
|---|---|
| Splash | Onboarding |
| Onboarding | Location Permission |
| Location Permission | Places |
| Places | Place Details, No Results |
| Place Details | Maps App, Saved |
| Learn | Flashcard |
| Flashcard | Learn, Quiz |
| Quiz | Results |
| Results | Quiz, Learn |
| Saved | Place Details, Places |

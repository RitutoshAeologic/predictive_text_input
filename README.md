# predictive_text_input

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

# Flutter Predictive Text Engine (Offline Autocomplete Demo)

A lightweight predictive text engine built in Flutter that works **fully offline**.
The system generates real-time suggestions while typing using a local dictionary, user-learned words, and a simple language model.

This project demonstrates how predictive typing can be implemented **without AI APIs, backend services, or cloud inference**.

---

## Features

* Real-time word suggestions
* Inline autocomplete (similar to Gmail)
* Keyboard suggestion bar
* Local word learning
* Next-word prediction using bigram model
* Offline dictionary with 10,000+ words
* Fully local processing (no internet required)

---

## Demo Behavior

### Prefix Prediction

When the user types a prefix:

```
fl
```

Suggestions appear:

```
flutter   flow   flight   flower
```

Selecting a suggestion replaces the current word and continues typing.

---

### Next Word Prediction

When the user finishes typing a word and presses space, the engine predicts the next word.

Example:

```
I love
```

Suggestions:

```
flutter   coding   technology
```

These predictions are learned from previous typing patterns.

---

## Architecture

The project follows a simple modular architecture.

```
UI Layer
  └─ PredictiveScreen
      ├─ InlineSuggestionField
      └─ KeyboardSuggestionBar

Controller Layer
  └─ PredictionController

Use Case Layer
  └─ GetSuggestionsUseCase

Repository Layer
  └─ PredictionRepositoryImpl

Data Sources
  ├─ Base Dictionary (JSON)
  ├─ User Learned Words (Hive)
  └─ Bigram Word Pairs
```

Each layer has a clear responsibility, making the system easy to extend or replace.

---

## Project Structure

```
lib
│
├── core
│   ├── services
│   │   └── hive_service.dart
│   │
│   └── dictionary
│       └── local_dictionary.dart
│
├── data
│   ├── models
│   │   └── word_model.dart
│   │
│   └── repositories
│       └── prediction_repository_impl.dart
│
├── domain
│   ├── entities
│   │   └── word_suggestion.dart
│   │
│   └── usecases
│       └── get_suggestions_usecase.dart
│
├── presentation
│   ├── controller
│   │   └── prediction_controller.dart
│   │
│   ├── screens
│   │   └── predictive_screen.dart
│   │
│   └── widgets
│       ├── inline_suggestion_field.dart
│       └── keyboard_suggestion_bar.dart
│
└── main.dart
```

---

## Dictionary

The base dictionary contains **10,000+ common English words**.

It is generated from a public dataset and stored locally as a JSON asset.

Example:

```
assets/dictionaries/base_words.json
```

Each word has a base frequency score used for ranking predictions.

Example:

```
{
  "flutter": 50,
  "science": 40,
  "doctor": 35,
  "apple": 30
}
```

---

## Local Learning with Hive

The prediction engine learns from the user.

Whenever a word is typed or selected, the system stores it locally with a frequency score.

Example stored data:

```
word: "flutter"
frequency: 5
```

Words used more often appear earlier in suggestions.

---

## Next Word Prediction (Bigram Model)

The system also stores pairs of words.

Example:

```
I → love
love → flutter
flutter → development
```

When a user types:

```
I love
```

The system predicts:

```
flutter
coding
technology
```

This allows context-aware predictions.

---

## Performance

The prediction engine is designed to run efficiently on mobile devices.

Optimizations include:

* Prefix filtering instead of full dictionary scanning
* In-memory dictionary caching
* Lightweight frequency scoring
* Local persistence using Hive

Suggestions are generated in real time with minimal latency.

---

## Running the Project

### 1. Install dependencies

```
flutter pub get
```

### 2. Generate the dictionary

```
dart run tool/generate_dictionary.dart
```

This will create:

```
assets/dictionaries/base_words.json
```

---

### 3. Run the application

```
flutter run
```

---

## Future Improvements

Possible enhancements include:

* Typo correction using Levenshtein distance
* Trigram language models
* Multilingual dictionary support
* Personal vocabulary profiles
* Context-aware ranking

---

## Purpose of This Project

This project is intended as a **technical demonstration** showing how predictive typing can be implemented using simple algorithms and local storage.

It can serve as a foundation for:

* search interfaces
* messaging apps
* note-taking editors
* form inputs with smart suggestions

---

## License

This project is provided for educational and demonstration purposes.

import 'dart:math';

import 'package:wordle_timeshiftmedia/models/word_guess.dart';

enum GameStatus { initial, inProgress, win, gameOver }

class GameState {
  // Enum for the current status of the game
  final GameStatus status;
  // Number of guesses remaining
  final int remainingGuesses;
  // List of word guesses
  final List<WordGuess?> wordGuesses;

  // Map of letters guessed in the correct place and their position
  Map<int, String> get correctLetters => wordGuesses.fold(
    {},
    (map, elem) => {...map, ...elem?.guessedLettersInCorrectPlace ?? {}},
  );

  // Map of letters guessed in the wrong place and their position
  // <Letter, Number of times it is in the word>
  Map<String, int> get guessedLettersInWrongPlace {
    final map = <String, int>{};
    for (var guess in wordGuesses) {
      if (guess != null) {
        for (var letter in guess.guessedLettersInWrongPlace.keys) {
          // If the letter is already in the map, update the count
          map[letter] = max(
            map[letter] ?? 0,
            guess.guessedLettersInWrongPlace[letter] ?? 0,
          );
        }
      }
    }
    return map;
  }

  Set<String> get incorrectLetters =>
      wordGuesses
          .fold(
            <String>[],
            (list, elem) => [...list, ...elem?.incorrectLetters ?? []],
          )
          .toSet();

  GameState({
    required this.status,
    required this.remainingGuesses,
    required this.wordGuesses,
  });

  GameState.initial(int maxGuesses)
    : status = GameStatus.initial,
      remainingGuesses = maxGuesses,
      wordGuesses = [];

  GameState copyWith({
    GameStatus? status,
    int? remainingGuesses,
    List<WordGuess?>? wordGuesses,
  }) {
    return GameState(
      status: status ?? this.status,
      remainingGuesses: remainingGuesses ?? this.remainingGuesses,
      wordGuesses: wordGuesses ?? this.wordGuesses,
    );
  }
}

import 'dart:math';

import 'package:wordle_timeshiftmedia/consts.dart';
import 'package:wordle_timeshiftmedia/models/game_state.dart';
import 'package:wordle_timeshiftmedia/models/word.dart';
import 'package:wordle_timeshiftmedia/models/word_guess.dart';

class GameBoard {
  GameBoard({required this.maxGuesses, int? wordIndex})
    : dailyWord = Word(
        validWordList[wordIndex ??
            Random.secure().nextInt(validWordList.length)],
      ),
      gameState = GameState.initial(maxGuesses);

  const GameBoard._(this.dailyWord, this.maxGuesses, GameState state)
    : gameState = state;

  GameBoard copyWithState(GameState state) {
    return GameBoard._(dailyWord, maxGuesses, state);
  }

  final Word dailyWord;
  final int maxGuesses;
  final GameState gameState;

  bool get isGameOver => gameState.status == GameStatus.gameOver;

  bool get isWin => gameState.status == GameStatus.win;

  bool isGuessValid(Word guess) {
    for (var i = 0; i < guess.letters.length; i++) {
      if (guess.letters[i] != dailyWord.letters[i]) {
        return false;
      }
    }
    return true;
  }
}

GameState validateGuess(GameBoard gameBoard, Word guess) {
  // If game is not finalized
  if (gameBoard.gameState.status == GameStatus.initial ||
      gameBoard.gameState.status == GameStatus.inProgress) {
    if (validWordList.contains(guess.value) == false) {
      throw WordNotInListException(guess.value);
    }
    if (gameBoard.gameState.wordGuesses.any(
      (prevGuess) => prevGuess?.word.value == guess.value,
    )) {
      throw RepeatedWordInputException(guess.value);
    }
    // If guess is valid, return win state
    if (gameBoard.isGuessValid(guess)) {
      final correctWordGuess = WordGuess(
        word: guess,
        guessedLettersInCorrectPlace: {
          for (var i = 0; i < guess.letters.length; i++) i: guess.letters[i],
        },
        guessedLettersInWrongPlace: {},
        incorrectLetters: [],
      );
      return gameBoard.gameState.copyWith(
        status: GameStatus.win,
        remainingGuesses: gameBoard.gameState.remainingGuesses - 1,
        wordGuesses: [...gameBoard.gameState.wordGuesses, correctWordGuess],
      );
      // If guess is invalid, calculate the correct and incorrect letters and positions
    } else {
      final correctPositionLetters = <int, String>{};
      final incorrectPositionLetters = <String, int>{};
      final incorrectLetters = <String>[];
      for (var i = 0; i < guess.letters.length; i++) {
        // Get teh correct position letters
        if (gameBoard.dailyWord.letters[i] == guess.letters[i]) {
          correctPositionLetters[i] = guess.letters[i];
        } else {
          // Get the incorrect position letters
          if (gameBoard.dailyWord.letters.contains(guess.letters[i])) {
            incorrectPositionLetters[guess.letters[i]] =
                (incorrectPositionLetters[guess.letters[i]] ?? 0) + 1;
          } else {
            // Get the incorrect letters
            incorrectLetters.add(guess.letters[i]);
          }
        }
      }
      // Create the word guess object
      // This is created to keep track of all the guesses and their positions
      final wordGuess = WordGuess(
        word: guess,
        guessedLettersInCorrectPlace: correctPositionLetters,
        guessedLettersInWrongPlace: incorrectPositionLetters,
        incorrectLetters: incorrectLetters,
      );

      if (gameBoard.gameState.remainingGuesses == 1) {
        return gameBoard.gameState.copyWith(
          status: GameStatus.gameOver,
          remainingGuesses: 0,
          wordGuesses: [...gameBoard.gameState.wordGuesses, wordGuess],
        );
      }

      return gameBoard.gameState.copyWith(
        status: GameStatus.inProgress,
        remainingGuesses: gameBoard.gameState.remainingGuesses - 1,
        wordGuesses: [...gameBoard.gameState.wordGuesses, wordGuess],
      );
    }
  } else {
    throw GameFinishedException(
      'Game is finished: status = ${gameBoard.gameState.status}',
    );
  }
}

class GameFinishedException implements Exception {
  GameFinishedException(this.message);

  final String message;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_timeshiftmedia/models/game_board.dart';
import 'package:wordle_timeshiftmedia/models/game_state.dart';
import 'package:wordle_timeshiftmedia/models/word.dart';

void main() {
  late GameBoard gameBoard;
  setUp(() {
    gameBoard = GameBoard(maxGuesses: 6, wordIndex: 46);
  });

  test('GameBoard should be created with a daily word', () {
    expect(gameBoard.dailyWord, isNotNull);
    expect(gameBoard.dailyWord.letters.length, equals(5));
    // Check the game state
    expect(gameBoard.gameState.status, equals(GameStatus.initial));
    expect(gameBoard.gameState.remainingGuesses, equals(6));
    expect(
      gameBoard.gameState.wordGuesses.every((guess) => guess == null),
      isTrue,
    );
    expect(gameBoard.gameState.correctLetters, isEmpty);
    expect(gameBoard.gameState.guessedLettersInWrongPlace, isEmpty);
    expect(gameBoard.gameState.incorrectLetters, isEmpty);
  });

  test('GameBoard should validate a guess and return a win state', () {
    final guess = Word('RAMEN');
    final result = validateGuess(gameBoard, guess);
    expect(result, isNotNull);
    expect(result.status, equals(GameStatus.win));
    expect(
      result.correctLetters,
      equals({0: 'r', 1: 'a', 2: 'm', 3: 'e', 4: 'n'}),
    );
    expect(result.guessedLettersInWrongPlace, isEmpty);
    expect(result.incorrectLetters, isEmpty);
  });

  test(
    'GameBoard should validate a guess and after win state, it should throw an exception if a guess is tried',
    () {
      var board = gameBoard;
      final guess = Word('RAMEN');
      final result = validateGuess(board, guess);
      expect(result.status, equals(GameStatus.win));
      board = board.copyWithState(result);
      expect(
        () => validateGuess(board, guess),
        throwsA(isA<GameFinishedException>()),
      );
    },
  );

  test(
    'GameBoard should validate a guess and return in progress state (4 correct, 1 incorrect)',
    () {
      final guess = Word('RAMON');
      final result = validateGuess(gameBoard, guess);
      expect(result, isNotNull);
      expect(result.status, equals(GameStatus.inProgress));
      expect(result.remainingGuesses, equals(5));
      expect(result.correctLetters, equals({0: 'r', 1: 'a', 2: 'm', 4: 'n'}));
      expect(result.guessedLettersInWrongPlace, isEmpty);
      expect(result.incorrectLetters, contains('o'));
    },
  );

  test(
    'GameBoard should validate a guess and return in progress state (2 correct, 1 incorrect, 2 wrong place)',
    () {
      final guess = Word('RANGE');
      final result = validateGuess(gameBoard, guess);
      expect(result, isNotNull);
      expect(result.status, equals(GameStatus.inProgress));
      expect(result.correctLetters, equals({0: 'r', 1: 'a'}));
      expect(result.guessedLettersInWrongPlace, equals({'e': 1, 'n': 1}));
      expect(result.incorrectLetters, contains('g'));
    },
  );

  test(
    'GameBoard should validate several guesses and return game over state',
    () {
      var board = gameBoard;

      final guess1 = Word('BLEAK');
      final result1 = validateGuess(board, guess1);
      expect(result1.status, equals(GameStatus.inProgress));
      expect(result1.remainingGuesses, equals(5));
      board = board.copyWithState(result1);

      final guess2 = Word('MASON');
      final result2 = validateGuess(board, guess2);
      expect(result2.status, equals(GameStatus.inProgress));
      expect(result2.remainingGuesses, equals(4));
      board = board.copyWithState(result2);

      final guess3 = Word('BURLY');
      final result3 = validateGuess(board, guess3);
      expect(result3.status, equals(GameStatus.inProgress));
      expect(result3.remainingGuesses, equals(3));
      board = board.copyWithState(result3);

      final guess4 = Word('KIOSK');
      final result4 = validateGuess(board, guess4);
      expect(result4.status, equals(GameStatus.inProgress));
      expect(result4.remainingGuesses, equals(2));
      board = board.copyWithState(result4);

      final guess5 = Word('IRATE');
      final result5 = validateGuess(board, guess5);
      expect(result5.status, equals(GameStatus.inProgress));
      expect(result5.remainingGuesses, equals(1));
      board = board.copyWithState(result5);

      final guess6 = Word('CACHE');
      final result6 = validateGuess(board, guess6);
      expect(result6.remainingGuesses, equals(0));
      expect(result6.status, equals(GameStatus.gameOver));
      board = board.copyWithState(result6);

      // After the game has finished, the board should throw an exception if a guess is tried
      final guess7 = Word('RATIO');
      expect(
        () => validateGuess(board, guess7),
        throwsA(isA<GameFinishedException>()),
      );
    },
  );

  test(
    'GameBoard should validate a guess and throw Exception if word is not in list',
    () {
      final guess = Word('RANDO');
      expect(
        () => validateGuess(gameBoard, guess),
        throwsA(isA<WordNotInListException>()),
      );
    },
  );

  test(
    'GameBoard should validate a guess and throw Exception if word was already input',
    () {
      final guess = Word('RANDO');
      expect(
        () => validateGuess(gameBoard, guess),
        throwsA(isA<WordNotInListException>()),
      );
    },
  );
}

import 'package:wordle_timeshiftmedia/models/word.dart';

class WordGuess {
  final Word word;
  final Map<int, String> guessedLettersInCorrectPlace;
  // <Letter, Number of times it is in the word>
  final Map<String, int> guessedLettersInWrongPlace;
  final List<String> incorrectLetters;

  WordGuess({
    required this.word,
    required this.guessedLettersInCorrectPlace,
    required this.guessedLettersInWrongPlace,
    required this.incorrectLetters,
  });
}

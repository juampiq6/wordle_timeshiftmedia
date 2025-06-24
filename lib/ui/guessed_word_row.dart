import 'package:flutter/material.dart';
import 'package:wordle_timeshiftmedia/consts.dart';
import 'package:wordle_timeshiftmedia/models/word_guess.dart';
import 'package:wordle_timeshiftmedia/ui/letter_field.dart';

class GuessedWordRow extends StatelessWidget {
  final WordGuess wordGuess;
  const GuessedWordRow({super.key, required this.wordGuess});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: List.generate(wordLength, (j) {
        final letter = wordGuess.word.letters[j];
        final correctPlace =
            wordGuess.guessedLettersInCorrectPlace[j] == letter;
        final incorrectPlace = wordGuess.guessedLettersInWrongPlace.keys
            .contains(letter);
        return LetterField(
          letter: letter.toUpperCase(),
          color:
              correctPlace
                  ? Colors.green
                  : incorrectPlace
                  ? Colors.yellow
                  : Colors.grey[200],
        );
      }),
    );
  }
}

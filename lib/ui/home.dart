import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:wordle_timeshiftmedia/consts.dart';
import 'package:wordle_timeshiftmedia/models/game_board.dart';
import 'package:wordle_timeshiftmedia/models/word.dart';
import 'package:wordle_timeshiftmedia/ui/input_word_row.dart';
import 'package:wordle_timeshiftmedia/ui/letter_field.dart';
import 'package:wordle_timeshiftmedia/ui/guessed_word_row.dart';

class WordleHome extends StatefulWidget {
  const WordleHome({super.key});

  @override
  State<WordleHome> createState() => _WordleHomeState();
}

class _WordleHomeState extends State<WordleHome> {
  GameBoard _gameBoard = GameBoard(maxGuesses: 6);

  int currentRowIndex = 0;

  void resetGame() {
    Phoenix.rebirth(context);
  }

  @override
  Widget build(BuildContext context) {
    print(_gameBoard.dailyWord.value);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'WORDLE TIMESHIFT MEDIA',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              _gameBoard.dailyWord.value.toUpperCase(),
              style: TextStyle(fontSize: 16, color: Colors.black26),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 30,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var e in _gameBoard.gameState.wordGuesses)
                  if (e != null) GuessedWordRow(wordGuess: e),
                if (_gameBoard.gameState.wordGuesses.length <
                    _gameBoard.maxGuesses)
                  InputWordRow(onSubmit: submitGuess),
                for (
                  int i = 0;
                  i <
                      _gameBoard.maxGuesses -
                          _gameBoard.gameState.wordGuesses.length -
                          1;
                  i++
                )
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: List.generate(wordLength, (j) {
                      return LetterField();
                    }),
                  ),
              ],
            ),
          ),
          // Keyboard
        ],
      ),
    );
  }

  void submitGuess(String guess) async {
    if (guess.length == wordLength) {
      try {
        _gameBoard = _gameBoard.copyWithState(
          validateGuess(_gameBoard, Word(guess)),
        );
        setState(() {});
      } catch (e) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
        );
        return;
      }
      if (_gameBoard.isWin) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('You won!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Play again'),
                  ),
                ],
              ),
        );
        resetGame();
        return;
      }
      if (_gameBoard.isGameOver) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('You lost!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Play again'),
                  ),
                ],
              ),
        );
        resetGame();
        return;
      }
    }
  }
}

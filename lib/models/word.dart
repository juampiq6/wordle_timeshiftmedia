import 'package:wordle_timeshiftmedia/consts.dart';

class Word {
  final String value;
  Word(String v) : value = v.toLowerCase();

  List<String> get letters => value.split('');
}

class WordNotInListException implements Exception {
  WordNotInListException(this.word);

  final String word;

  @override
  String toString() {
    return 'WordNotInListException: $word';
  }
}

class RepeatedWordInputException implements Exception {
  RepeatedWordInputException(this.word);

  final String word;

  @override
  String toString() {
    return 'RepeatedWordInputException: $word';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle_timeshiftmedia/consts.dart';
import 'package:wordle_timeshiftmedia/ui/letter_field.dart';

class InputWordRow extends StatefulWidget {
  final Function(String) onSubmit;
  const InputWordRow({super.key, required this.onSubmit});

  @override
  State<InputWordRow> createState() => _InputWordRowState();
}

class _InputWordRowState extends State<InputWordRow> {
  final List<TextEditingController> _controllers = List.generate(
    wordLength,
    (index) => TextEditingController(),
  );
  final FocusNode _focusNode = FocusNode();
  int cursorIndex = 0;

  @override
  void dispose() {
    _focusNode.dispose();
    for (var e in _controllers) {
      e.dispose();
    }
    super.dispose();
  }

  void onKeyPressed(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      if (cursorIndex == wordLength - 1) {
        widget.onSubmit(_controllers.map((e) => e.text).join());
      }
    }
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[cursorIndex].text.isEmpty && cursorIndex > 0) {
        _controllers[cursorIndex - 1].clear();
      } else {
        _controllers[cursorIndex].clear();
      }
      if (cursorIndex > 0) {
        cursorIndex--;
      }
      setState(() {});
    }
    if (event.character != null) {
      _controllers[cursorIndex].text = event.character!.toUpperCase();
      if (cursorIndex < wordLength - 1) {
        cursorIndex++;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: onKeyPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: List.generate(wordLength, (j) {
          return LetterField(letter: _controllers[j].text);
        }),
      ),
    );
  }
}

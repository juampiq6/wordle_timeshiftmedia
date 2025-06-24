import 'dart:math';

import 'package:flutter/material.dart';

class LetterField extends StatelessWidget {
  const LetterField({super.key, this.letter, this.color});
  final Color? color;
  final String? letter;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final size = min(screenSize.width, screenSize.height) * 0.1;
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      width: size,
      height: size,
      child: Center(
        child: Text(letter ?? '', style: const TextStyle(fontSize: 48)),
      ),
    );
  }
}

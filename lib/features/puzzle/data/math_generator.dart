import 'dart:math';

import 'package:think_up/features/alarm/domain/entities/alarm.dart';

class MathGenerator {
  final Random _random = Random();

  Map<String, dynamic> generateProblem(PuzzleDifficulty difficulty) {
    int maxNumber = 10;
    int minNumber = 1;

    switch (difficulty) {
      case PuzzleDifficulty.easy:
        maxNumber = 10;
        break;
      case PuzzleDifficulty.medium:
        maxNumber = 50;
        break;
      case PuzzleDifficulty.hard:
        maxNumber = 100;
        break;
    }

    int num1 = _random.nextInt(maxNumber - minNumber) + minNumber;

    int num2 = _random.nextInt(maxNumber - minNumber) + minNumber;

    String operation = '+';
    int answer = num1 + num2;

    String problem = '$num1 $operation $num2';

    return {'problem': problem, 'answer': answer};
  }
}

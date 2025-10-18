import 'package:flutter/material.dart';
import 'package:think_up/app/router.dart';
import 'package:think_up/features/alarm/domain/entities/alarm.dart';
import 'package:think_up/features/puzzle/data/math_generator.dart';

class MathPuzzleScreen extends StatefulWidget {
  final PuzzleDifficulty difficulty;
  final int alarmId;

  const MathPuzzleScreen({
    super.key,
    required this.difficulty,
    required this.alarmId,
  });

  @override
  State<MathPuzzleScreen> createState() => _MathPuzzleScreenState();
}

class _MathPuzzleScreenState extends State<MathPuzzleScreen> {
  final TextEditingController _controller = TextEditingController();
  final MathGenerator _mathGenerator = MathGenerator();

  late Map<String, dynamic> _currentProblem;
  String _message = "Solve to dismiss alarm";

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  void _generateNewProblem() {
    _currentProblem = _mathGenerator.generateProblem(widget.difficulty);
    _controller.clear();
    setState(() {});
  }

  void _checkAnswer() {
    final userAnswer = _controller.text.trim();

    if (userAnswer.isNotEmpty &&
        int.tryParse(userAnswer) == _currentProblem["answer"]) {
      AppRouter.navigatorKey.currentState?.pushReplacementNamed(
        "/alarm-ring",
        arguments: {"alarmId": int.tryParse(widget.alarmId.toString())},
      );
    } else {
      setState(() {
        _message = "Incorrect! Try again.";
      });
      _generateNewProblem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Puzzle'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentProblem["problem"],
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains("Incorrect")
                    ? Colors.red
                    : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Your Answer',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkAnswer(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _checkAnswer,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('SOLVE & STOP', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

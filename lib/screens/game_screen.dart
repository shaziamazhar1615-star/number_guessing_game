import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int secretNumber = Random().nextInt(100) + 1;
  int attempts = 0;
  bool isWon = false;

  String message = 'Guess a number between 1 and 100';

  final controller = TextEditingController();
  final db = DatabaseHelper();

  void checkGuess() async {
    int? guess = int.tryParse(controller.text);

    if (guess == null || guess < 1 || guess > 100) {
      setState(() {
        message = 'Enter a number between 1 and 100';
      });
      return;
    }

    if (isWon) return;

    setState(() {
      attempts++;
    });

    if (guess == secretNumber) {
      setState(() {
        isWon = true;
        message = 'Congratulations! You Won!';
      });

      // Save record on supported desktop platforms
      if (!kIsWeb) {
        await db.insertGame(secretNumber, attempts);
      }
    } else {
      setState(() {
        message = guess < secretNumber
            ? 'Too Low! Try Higher'
            : 'Too High! Try Lower';
      });
    }

    controller.clear();
  }

  void restartGame() {
    setState(() {
      secretNumber = Random().nextInt(100) + 1;
      attempts = 0;
      isWon = false;
      message = 'Guess a number between 1 and 100';
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guessing Game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              const SizedBox(height: 20),

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter your guess',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: isWon ? null : checkGuess,
                child: const Text('Check Guess'),
              ),

              Text('Attempts: $attempts'),

              ElevatedButton(
                onPressed: restartGame,
                child: const Text('Restart Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
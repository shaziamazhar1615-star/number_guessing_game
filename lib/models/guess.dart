class Guess {
  int secretNumber;
  int attempts;

  Guess({
    required this.secretNumber,
    this.attempts = 0,
  });

  bool checkGuess(int number) {
    attempts++;
    return number == secretNumber;
  }
}
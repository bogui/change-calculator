import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Using the same exchange rate as the converter
const double _exchangeRate = 1.95583;

class QuickConversionChallengeScreen extends StatefulWidget {
  const QuickConversionChallengeScreen({super.key});

  @override
  State<QuickConversionChallengeScreen> createState() =>
      _QuickConversionChallengeScreenState();
}

class _QuickConversionChallengeScreenState
    extends State<QuickConversionChallengeScreen> {
  // Game state variables
  int _score = 0;
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 10;
  Timer? _roundTimer;
  int _timeRemaining = 60;

  // Game data
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _score = 0;
    _currentQuestionIndex = 0;
    _timeRemaining = 60;
    _questions = _generateQuestions();
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    _roundTimer?.cancel();
    _roundTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        _endGame();
      }
    });
  }

  List<Map<String, dynamic>> _generateQuestions() {
    final random = Random();
    return List.generate(_totalQuestions, (index) {
      final bool isBgnToEur = random.nextBool();
      final double amount = (random.nextDouble() * 199.5) + 0.5;

      double correctAnswer;
      String questionText;
      if (isBgnToEur) {
        questionText = '${amount.toStringAsFixed(2)} BGN = ? EUR';
        correctAnswer = amount / _exchangeRate;
      } else {
        questionText = '${amount.toStringAsFixed(2)} EUR = ? BGN';
        correctAnswer = amount * _exchangeRate;
      }

      List<double> options = [correctAnswer];
      while (options.length < 4) {
        double wrongAnswer;
        int type = random.nextInt(3);
        if (type == 0) {
          // Close answer
          wrongAnswer =
              correctAnswer * (1 + (random.nextDouble() - 0.5) * 0.1); // +/- 5%
        } else if (type == 1) {
          // Rough answer
          wrongAnswer =
              correctAnswer * (1 + (random.nextDouble() - 0.5) * 0.4); // +/- 20%
        } else {
          // Distractor
          wrongAnswer = (isBgnToEur
                  ? amount * _exchangeRate
                  : amount / _exchangeRate) *
              (1 + (random.nextDouble() - 0.5) * 0.2);
        }
        // Ensure wrong answer is not too close to correct answer or other options
        if (!options.any((opt) => (opt - wrongAnswer).abs() < 0.05)) {
          options.add(wrongAnswer);
        }
      }
      options.shuffle();

      return {
        'question': questionText,
        'options': options,
        'correctAnswer': correctAnswer,
      };
    });
  }

  void _answerQuestion(double selectedAnswer) {
    _roundTimer?.cancel(); // Pause timer while showing feedback

    final correctAnswer = _questions[_currentQuestionIndex]['correctAnswer'];
    final bool isCorrect = (selectedAnswer - correctAnswer).abs() < 0.01;

    if (isCorrect) {
      setState(() {
        _score += 100 + (_timeRemaining > 0 ? (_timeRemaining % 6) * 5 : 0);
      });
    } else {
      setState(() {
        _score -= 50;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isCorrect
          ? 'Correct!'
          : 'Wrong! The answer was ${correctAnswer.toStringAsFixed(2)}'),
      duration: const Duration(milliseconds: 800),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
    ));

    Future.delayed(const Duration(milliseconds: 900), () {
      if (_currentQuestionIndex < _totalQuestions - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
        _startTimer();
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    _roundTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Round Over!'),
          content: Text('Your final score is: $_score'),
          actions: [
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
            ),
            TextButton(
              child: const Text('Back to Menu'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to MiniGamesScreen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final questionData = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Conversion Challenge'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
                child: Text('Score: $_score',
                    style: Theme.of(context).textTheme.titleMedium)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question: ${_currentQuestionIndex + 1}/$_totalQuestions',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('Time: $_timeRemaining',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _timeRemaining / 60),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                questionData['question'],
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: (questionData['options'] as List<double>).map((option) {
                  return ElevatedButton(
                    onPressed: () => _answerQuestion(option),
                    child: Text(
                      option.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

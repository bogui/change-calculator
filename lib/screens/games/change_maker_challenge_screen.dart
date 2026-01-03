import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const double _exchangeRate = 1.95583;

class ChangeMakerChallengeScreen extends StatefulWidget {
  const ChangeMakerChallengeScreen({super.key});

  @override
  State<ChangeMakerChallengeScreen> createState() =>
      _ChangeMakerChallengeScreenState();
}

class _ChangeMakerChallengeScreenState
    extends State<ChangeMakerChallengeScreen> {
  // Game state variables
  int _score = 0;
  int _currentTransactionIndex = 0;
  final int _totalTransactions = 8;
  Timer? _roundTimer;
  int _timeRemaining = 90;

  // Game data
  List<Map<String, dynamic>> _transactions = [];
  final TextEditingController _changeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _roundTimer?.cancel();
    _changeController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _currentTransactionIndex = 0;
      _timeRemaining = 90;
      _transactions = _generateTransactions();
      _changeController.clear();
    });
    _startTimer();
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

  List<Map<String, dynamic>> _generateTransactions() {
    final random = Random();
    return List.generate(_totalTransactions, (index) {
      // Bill total between 5 and 50 BGN
      final double bgnBill = 5.0 + random.nextDouble() * 45.0;
      final double eurBill = bgnBill / _exchangeRate;

      // Paid amount in EUR, ensuring it's enough
      final List<double> validPayments = [5.0, 10.0, 20.0, 50.0, 100.0]
          .where((p) => p > eurBill)
          .toList();
      final double eurPaid = validPayments[random.nextInt(validPayments.length)];

      final double correctChange = eurPaid - eurBill;

      return {
        'bgnBill': bgnBill,
        'eurPaid': eurPaid,
        'correctChange': correctChange,
      };
    });
  }

  void _submitChange() {
    final submittedValue = double.tryParse(_changeController.text);
    if (submittedValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid amount.'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    final correctChange =
        _transactions[_currentTransactionIndex]['correctChange'] as double;
    final difference = (submittedValue - correctChange).abs();

    String feedbackText;
    Color feedbackColor;

    if (difference <= 0.01) { // Exact match
      setState(() => _score += 200);
      feedbackText = 'Perfect! Correct change.';
      feedbackColor = Colors.green;
    } else if (difference <= 0.05) { // Near correct
      setState(() => _score += 100);
      feedbackText = 'Close! The exact change is ${correctChange.toStringAsFixed(2)} EUR.';
      feedbackColor = Colors.lightGreen;
    } else { // Incorrect
      setState(() => _score -= 100);
      feedbackText = 'Incorrect. The correct change is ${correctChange.toStringAsFixed(2)} EUR.';
      feedbackColor = Colors.red;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(feedbackText),
      duration: const Duration(milliseconds: 1200),
      backgroundColor: feedbackColor,
    ));

    _changeController.clear();
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      if (_currentTransactionIndex < _totalTransactions - 1) {
        setState(() {
          _currentTransactionIndex++;
        });
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty || _currentTransactionIndex >= _transactions.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final transactionData = _transactions[_currentTransactionIndex];
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Maker Challenge'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text('Score: $_score', style: textTheme.titleMedium),
            ),
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
                Text('Transaction: ${_currentTransactionIndex + 1}/$_totalTransactions',
                    style: textTheme.titleSmall),
                Text('Time: $_timeRemaining', style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _timeRemaining / 90),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Bill Total', style: textTheme.titleMedium),
                        Text('${transactionData['bgnBill'].toStringAsFixed(2)} BGN',
                            style: textTheme.headlineSmall),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                    Column(
                      children: [
                        Text('Paid With', style: textTheme.titleMedium),
                        Text('${transactionData['eurPaid'].toStringAsFixed(2)} EUR',
                            style: textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Change in EUR', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _changeController,
              readOnly: true,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0.00',
                border: OutlineInputBorder(),
                suffixText: 'EUR',
              ),
            ),
            const Spacer(),
            _NumericKeypad(
              controller: _changeController,
              onSubmit: _submitChange,
            ),
          ],
        ),
      ),
    );
  }
}

class _NumericKeypad extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _NumericKeypad({required this.controller, required this.onSubmit});

  void _onNumberTap(String number) {
    final currentText = controller.text;
    if (number == '.') {
      if (!currentText.contains('.')) {
        controller.text = currentText.isEmpty ? '0.' : '$currentText.';
      }
    } else {
      // Limit to 2 decimal places
      if (currentText.contains('.') && currentText.split('.')[1].length < 2) {
        controller.text += number;
      }
      if (!currentText.contains('.')){
         controller.text += number;
      }
    }
  }

  void _onBackspace() {
    final currentText = controller.text;
    if (currentText.isNotEmpty) {
      controller.text = currentText.substring(0, currentText.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3']
              .map((e) => Expanded(child: TextButton(onPressed: () => _onNumberTap(e), child: Text(e, style: Theme.of(context).textTheme.headlineSmall), style: buttonStyle)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6']
              .map((e) => Expanded(child: TextButton(onPressed: () => _onNumberTap(e), child: Text(e, style: Theme.of(context).textTheme.headlineSmall), style: buttonStyle)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9']
              .map((e) => Expanded(child: TextButton(onPressed: () => _onNumberTap(e), child: Text(e, style: Theme.of(context).textTheme.headlineSmall), style: buttonStyle)))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: TextButton(onPressed: () => _onNumberTap('.'), child: Text('.', style: Theme.of(context).textTheme.headlineSmall), style: buttonStyle)),
            Expanded(child: TextButton(onPressed: () => _onNumberTap('0'), child: Text('0', style: Theme.of(context).textTheme.headlineSmall), style: buttonStyle)),
            Expanded(child: TextButton(onPressed: _onBackspace, child: const Icon(Icons.backspace_outlined), style: buttonStyle)),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}

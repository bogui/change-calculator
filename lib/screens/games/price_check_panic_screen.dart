import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const double _exchangeRate = 1.95583;

// A predefined list of common items and their typical BGN prices.
const List<Map<String, dynamic>> _itemDatabase = [
  {'name': 'Bread', 'price': 1.80},
  {'name': 'Milk (1L)', 'price': 2.50},
  {'name': 'Coffee (cup)', 'price': 2.80},
  {'name': 'Bus Ticket', 'price': 1.60},
  {'name': 'Newspaper', 'price': 2.00},
  {'name': 'Mineral Water (1.5L)', 'price': 1.10},
  {'name': 'Chocolate Bar', 'price': 2.20},
  {'name': 'Pizza Slice', 'price': 4.50},
  {'name': 'Cinema Ticket', 'price': 15.00},
  {'name': 'Draft Beer (0.5L)', 'price': 4.00},
  {'name': 'Sandwich', 'price': 6.50},
  {'name': 'Salad', 'price': 8.00},
  {'name': 'Bottle of Wine (Mid-range)', 'price': 12.00},
  {'name': 'Taxi (5km)', 'price': 7.00},
  {'name': 'Museum Entry', 'price': 10.00},
];

enum PriceJudgement { goodDeal, badDeal, aboutRight }

class PriceCheckPanicScreen extends StatefulWidget {
  const PriceCheckPanicScreen({super.key});

  @override
  State<PriceCheckPanicScreen> createState() => _PriceCheckPanicScreenState();
}

class _PriceCheckPanicScreenState extends State<PriceCheckPanicScreen> {
  // Game state variables
  int _score = 0;
  int _currentItemIndex = 0;
  final int _totalItems = 10;
  Timer? _roundTimer;
  int _timeRemaining = 75;

  // Game data
  List<Map<String, dynamic>> _gameItems = [];

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
    _currentItemIndex = 0;
    _timeRemaining = 75;
    _gameItems = _generateGameItems();
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

  List<Map<String, dynamic>> _generateGameItems() {
    final random = Random();
    final shuffledDb = List<Map<String, dynamic>>.from(_itemDatabase)..shuffle();

    return List.generate(_totalItems, (index) {
      final item = shuffledDb[index];
      final bgnPrice = item['price'] as double;
      final exactEurPrice = bgnPrice / _exchangeRate;

      final judgementType = PriceJudgement.values[random.nextInt(3)];
      double proposedEurPrice;

      switch (judgementType) {
        case PriceJudgement.goodDeal:
          // At least 10% lower
          proposedEurPrice = exactEurPrice * (0.75 + random.nextDouble() * 0.15);
          break;
        case PriceJudgement.badDeal:
          // At least 10% higher
          proposedEurPrice = exactEurPrice * (1.1 + random.nextDouble() * 0.25);
          break;
        case PriceJudgement.aboutRight:
          // Within +/- 5%
          proposedEurPrice = exactEurPrice * (0.95 + random.nextDouble() * 0.1);
          break;
      }
      return {
        'name': item['name'],
        'bgnPrice': bgnPrice,
        'proposedEurPrice': proposedEurPrice,
        'correctJudgement': judgementType,
        'exactEurPrice': exactEurPrice,
      };
    });
  }

  void _makeJudgement(PriceJudgement userJudgement) {
    final correctJudgement =
        _gameItems[_currentItemIndex]['correctJudgement'] as PriceJudgement;
    final isCorrect = userJudgement == correctJudgement;

    if (isCorrect) {
      setState(() {
        _score += 150;
      });
    } else {
      setState(() {
        _score -= 75;
      });
    }

    final exactPrice = _gameItems[_currentItemIndex]['exactEurPrice'] as double;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        isCorrect
            ? 'Correct!'
            : 'Incorrect! The fair price is ~${exactPrice.toStringAsFixed(2)} EUR.',
      ),
      duration: const Duration(milliseconds: 900),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
    ));

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      if (_currentItemIndex < _totalItems - 1) {
        setState(() {
          _currentItemIndex++;
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
    if (_gameItems.isEmpty || _currentItemIndex >= _gameItems.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final itemData = _gameItems[_currentItemIndex];
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Check Panic'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
                child: Text('Score: $_score', style: textTheme.titleMedium)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Item: ${_currentItemIndex + 1}/$_totalItems',
                        style: textTheme.titleSmall),
                    Text('Time: $_timeRemaining', style: textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: _timeRemaining / 75),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(itemData['name'], style: textTheme.headlineSmall),
                        Text('${itemData['bgnPrice'].toStringAsFixed(2)} BGN',
                            style: textTheme.titleMedium),
                        const SizedBox(height: 20),
                        Text('Proposed Price:', style: textTheme.titleSmall),
                        Text(
                            '${itemData['proposedEurPrice'].toStringAsFixed(2)} EUR',
                            style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _JudgementButton(
                  label: 'Good Deal',
                  icon: Icons.thumb_up_outlined,
                  color: Colors.green,
                  onPressed: () => _makeJudgement(PriceJudgement.goodDeal),
                ),
                const SizedBox(height: 12),
                _JudgementButton(
                  label: 'About Right',
                  icon: Icons.thumbs_up_down_outlined,
                  color: Colors.orange,
                  onPressed: () => _makeJudgement(PriceJudgement.aboutRight),
                ),
                const SizedBox(height: 12),
                _JudgementButton(
                  label: 'Bad Deal',
                  icon: Icons.thumb_down_outlined,
                  color: Colors.red,
                  onPressed: () => _makeJudgement(PriceJudgement.badDeal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JudgementButton extends StatelessWidget {
  const _JudgementButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

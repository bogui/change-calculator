import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const double _exchangeRate = 1.95583;

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

class BudgetBuddyBattleScreen extends StatefulWidget {
  const BudgetBuddyBattleScreen({super.key});

  @override
  State<BudgetBuddyBattleScreen> createState() =>
      _BudgetBuddyBattleScreenState();
}

class _BudgetBuddyBattleScreenState extends State<BudgetBuddyBattleScreen> {
  // Game state variables
  int _score = 0;
  double _remainingBudget = 0;
  int _currentItemIndex = 0;
  final int _totalItems = 10;

  // Game data
  List<Map<String, dynamic>> _gameItems = [];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    final random = Random();
    setState(() {
      _score = 0;
      _currentItemIndex = 0;
      _remainingBudget = 20.0 + random.nextDouble() * 30.0; // Budget between 20-50 EUR
      _gameItems = _generateGameItems();
    });
  }

  List<Map<String, dynamic>> _generateGameItems() {
    final random = Random();
    final shuffledDb = List<Map<String, dynamic>>.from(_itemDatabase)..shuffle();
    return List.generate(_totalItems, (index) {
      final item = shuffledDb[index];
      final bool isEur = random.nextBool();
      return {
        'name': item['name'],
        'price': item['price'] as double,
        'isEur': isEur,
        'eurEquivalent': (item['price'] as double) / _exchangeRate,
      };
    });
  }

  void _buyItem() {
    final item = _gameItems[_currentItemIndex];
    final double costInEur = item['isEur'] ? item['price'] : item['eurEquivalent'];

    if (costInEur > _remainingBudget) {
      setState(() => _score -= 200);
      _endGame(budgetExceeded: true);
      return;
    }

    setState(() {
      _remainingBudget -= costInEur;
      _score += 100;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Bought ${item['name']}!'),
      duration: const Duration(milliseconds: 800),
      backgroundColor: Colors.blue,
    ));

    _nextItem();
  }

  void _skipItem() {
    setState(() => _score += 50);
    _nextItem();
  }

  void _nextItem() {
    if (_currentItemIndex < _totalItems - 1) {
      setState(() {
        _currentItemIndex++;
      });
    } else {
      _endGame();
    }
  }

  void _endGame({bool budgetExceeded = false}) {
    int finalScore = _score;
    if (!budgetExceeded) {
      final budgetBonus = (_remainingBudget * 10).floor();
      finalScore += budgetBonus;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(budgetExceeded ? 'Budget Exceeded!' : 'Round Over!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (budgetExceeded)
                const Text('You ran out of money.'),
              Text('Your final score is: $finalScore'),
            ],
          ),
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
        title: const Text('Budget Buddy Battle'),
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
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Remaining Budget', style: textTheme.titleLarge),
                    Text('${_remainingBudget.toStringAsFixed(2)} EUR',
                        style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Item ${_currentItemIndex + 1}/$_totalItems', style: textTheme.titleSmall),
            const Spacer(),
            Column(
              children: [
                Text('Item', style: textTheme.headlineSmall),
                Text(itemData['name'], style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Price', style: textTheme.headlineSmall),
                Text(
                    '${itemData['price'].toStringAsFixed(2)} ${itemData['isEur'] ? 'EUR' : 'BGN'}',
                    style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold, color: itemData['isEur'] ? Colors.green : Colors.orange)),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Buy'),
                    onPressed: _buyItem,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.skip_next_outlined),
                    label: const Text('Skip'),
                    onPressed: _skipItem,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

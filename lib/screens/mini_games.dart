import 'package:euro_converter/screens/games/budget_buddy_battle_screen.dart';
import 'package:euro_converter/screens/games/change_maker_challenge_screen.dart';
import 'package:euro_converter/screens/games/price_check_panic_screen.dart';
import 'package:euro_converter/screens/games/quick_conversion_challenge_screen.dart';
import 'package:flutter/material.dart';

/// A screen that displays a menu of available mini-games.
///
/// This screen serves as a hub for the "Financial Fluency Games" module,
/// listing each game with a title, description, and an entry point.
/// The games are based on the requirements from the project's PRD.
class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Fluency Games'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _GameCard(
            icon: Icons.bolt,
            title: 'Quick Conversion Challenge',
            description:
                'Convert amounts between BGN and EUR as fast as you can.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const QuickConversionChallengeScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _GameCard(
            icon: Icons.shopping_cart_checkout,
            title: 'Price Check Panic',
            description:
                'Judge if a price in EUR is a good deal for an item priced in BGN.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PriceCheckPanicScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _GameCard(
            icon: Icons.calculate_outlined,
            title: 'Change Maker Challenge',
            description:
                'Calculate the correct change in EUR for a bill in BGN.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangeMakerChallengeScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _GameCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Budget Buddy Battle',
            description:
                'Manage a budget by buying or skipping items to maximize purchases.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BudgetBuddyBattleScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A reusable widget that displays a single game option in a card.
///
/// Includes an icon, title, description, and a callback for when it's tapped.
class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

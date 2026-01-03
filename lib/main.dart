import 'package:euro_converter/screens/converter_screen.dart';
import 'package:euro_converter/screens/mini_games.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ресто калкулатор (лв. / €)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const AppNavigationController(),
    );
  }
}

/// This widget is the main navigation controller for the app.
/// It uses a [NavigationBar] to switch between different screens.
class AppNavigationController extends StatefulWidget {
  const AppNavigationController({super.key});

  @override
  State<AppNavigationController> createState() =>
      _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController> {
  int _selectedIndex = 0;

  // The list of screens to be displayed.
  static const List<Widget> _screens = <Widget>[
    ConverterScreen(),
    MiniGamesScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.calculate),
            icon: Icon(Icons.calculate_outlined),
            label: 'Калкулатор',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.games),
            icon: Icon(Icons.games_outlined),
            label: 'Игри',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(SudokuApp());
}

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.grey[200]!,
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.teal[400]!,
          primaryVariant: Colors.teal[200]!,
        ),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.grey[900]!,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.teal[400]!,
          primaryVariant: Colors.teal[700]!,
        ),
      ),
      home: Home(),
    );
  }
}

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: child,
    );
  }
}

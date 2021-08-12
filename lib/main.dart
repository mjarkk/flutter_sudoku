import 'package:flutter/material.dart';
import 'sudoku.dart';
import 'playground.dart';
import 'controls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: Colors.teal[400]!,
          primaryVariant: Colors.teal[200]!,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.teal[400]!,
          primaryVariant: Colors.teal[700]!,
        ),
      ),
      home: Scaffold(
        body: _Screen(),
      ),
    );
  }
}

class _Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  Sudoku _sudoku = new Sudoku();
  Cell? _selectedCell;
  SudokuField selectedField = SudokuField();

  updateSelectedField() {
    selectedField = _sudoku.getField(_selectedCell ?? Cell.empty());
  }

  setSelectCell(Cell cell) {
    setState(() {
      if (_selectedCell?.equal(cell) == true) {
        _selectedCell = null;
      } else {
        _selectedCell = cell;
        updateSelectedField();
      }
    });
  }

  onNumberSelect(int number) {
    setState(() {
      _sudoku.toggleFieldPosibility(
        _selectedCell ?? Cell.empty(),
        number,
      );
      updateSelectedField();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Playground(
            sudoku: _sudoku,
            setSelectCell: setSelectCell,
            selectedCell: _selectedCell,
          ),
          Controls(
            onNumberSelection: onNumberSelect,
            field: selectedField,
            cell: _selectedCell,
          )
        ],
      ),
    );
  }
}

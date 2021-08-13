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
    selectedField = _sudoku.getField(_selectedCell ?? Cell.placeholder());
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
        _selectedCell ?? Cell.placeholder(),
        number,
      );
      updateSelectedField();
    });
  }

  onNumberConfirm(int number) {
    Cell cell = _selectedCell ?? Cell.placeholder();
    if (!_sudoku.canSetFieldValue(cell, number)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Invalid value'),
          content: Text(
            number.toString() + ' cannot be used as value for this cell',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _sudoku.setFieldValue(cell, number);
      _selectedCell = null;
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
            onNumberConfirm: onNumberConfirm,
            field: selectedField,
            cell: _selectedCell,
          )
        ],
      ),
    );
  }
}

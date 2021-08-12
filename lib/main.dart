import 'package:flutter/material.dart';
import 'sudoku.dart';
import 'playground.dart';

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
  Sudoku sudoku = new Sudoku();
  Cell? selectedCell;
  SudokuField selectedField = SudokuField();

  updateSelectedField() {
    selectedField = sudoku.getField(selectedCell ?? Cell.empty());
  }

  onNumberSelect(int number) {
    setState(() {
      sudoku.toggleFieldPosibility(
        selectedCell ?? Cell.empty(),
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
            sudoku: sudoku,
            setSelectCell: (Cell cell) {
              setState(() {
                selectedCell = cell;
                updateSelectedField();
              });
            },
            selectedCell: selectedCell,
          ),
          selectedCell != null
              ? Controls(
                  onNumberSelection: onNumberSelect,
                  field: selectedField,
                )
              : Container(),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final Function(int) onNumberSelection;
  final SudokuField field;

  Controls({required this.onNumberSelection, required this.field});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10).copyWith(top: 0),
            child: Text(
              'Select posiblities',
              style: theme.textTheme.caption,
            ),
          ),
          Row(
            children: List.generate(9, (int j) {
              bool active = field.posibilities[j + 1] ?? false;

              return Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          active ? theme.colorScheme.primary : theme.cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        (j + 1).toString(),
                        style: active
                            ? theme.textTheme.button?.copyWith(fontSize: 20)
                            : theme.textTheme.bodyText1?.copyWith(fontSize: 20),
                      ),
                    ),
                    onPressed: () => onNumberSelection(j + 1),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

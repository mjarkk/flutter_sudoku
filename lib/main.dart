import 'package:flutter/material.dart';
import 'sudoku.dart';
import 'playground.dart';
import 'controls.dart';

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
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.teal[400]!,
          primaryVariant: Colors.teal[700]!,
        ),
      ),
      home: SudokuAppScaffold(),
    );
  }
}

class SudokuAppScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: _Screen(),
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

      if (_sudoku.allFieldsFilledIn()) {
        // TODO show congrats screen
        print("yay great success");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 300 || constraints.maxHeight < 400)
        return ScreenToSmall();

      bool horizontalLayout =
          constraints.maxHeight - constraints.maxWidth + 50 < 0;
      bool needSpaceForControls = (horizontalLayout
              ? (constraints.maxWidth - constraints.maxHeight)
              : (constraints.maxHeight - constraints.maxWidth)) <
          (horizontalLayout ? ControlsMinWidth : ControlsMinHeight) + 50;

      bool smallControls =
          constraints.maxWidth < 400 || constraints.maxHeight < 500;

      Playground playground = Playground(
        sudoku: _sudoku,
        setSelectCell: setSelectCell,
        selectedCell: _selectedCell,
      );

      return Center(
        child: horizontalLayout
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  needSpaceForControls
                      ? Expanded(
                          child: Center(
                            child: Container(
                              child: playground,
                            ),
                          ),
                        )
                      : Center(
                          child: Container(
                            child: playground,
                          ),
                        ),
                  Controls(
                    onNumberSelection: onNumberSelect,
                    onNumberConfirm: onNumberConfirm,
                    field: selectedField,
                    cell: _selectedCell,
                    layout: ControlsLayout.verticalLine,
                    small: smallControls,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  needSpaceForControls
                      ? Expanded(child: playground)
                      : playground,
                  Controls(
                    onNumberSelection: onNumberSelect,
                    onNumberConfirm: onNumberConfirm,
                    field: selectedField,
                    cell: _selectedCell,
                    layout: ControlsLayout.horizontalLine,
                    small: smallControls,
                  ),
                ],
              ),
      );
    });
  }
}

class ScreenToSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yo, i'm not a smartwatch",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.watch),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../logic/sudoku.dart';
import '../components/playground.dart';
import '../components/controls.dart';
import '../components/statusbar.dart';
import '../main.dart';

class Game extends StatefulWidget {
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  Sudoku _sudoku = new Sudoku();
  Cell? _selectedCell;
  SudokuField selectedField = SudokuField();

  bool finished = false;

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
      if (_sudoku.allFieldsFilledIn()) finished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) return AppScaffold(_Finished());

    return AppScaffold(Column(
      children: [
        StatusBar(),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 300 || constraints.maxHeight < 400)
              return _ScreenToSmall();

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
          }),
        ),
      ],
    ));
  }
}

class _Finished extends StatelessWidget {
  goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mood, size: 50),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Great success!!",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                  onPressed: () => goBack(context),
                  icon: Icon(Icons.arrow_left),
                  label: Text("Back to menu")),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenToSmall extends StatelessWidget {
  goBack(BuildContext context) {
    Navigator.pop(context);
  }

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
              child: ElevatedButton.icon(
                  onPressed: () => goBack(context),
                  icon: Icon(Icons.arrow_left),
                  label: Text("Back to menu")),
            ),
          ],
        ),
      ),
    );
  }
}

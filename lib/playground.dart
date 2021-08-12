import 'package:flutter/material.dart';
import 'sudoku.dart';

class Playground extends StatelessWidget {
  final Sudoku sudoku;
  final Function(Cell) setSelectCell;
  final Cell? selectedCell;

  Playground({
    required this.sudoku,
    required this.setSelectCell,
    required this.selectedCell,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: [
          for (var i = 0; i < 9; i++)
            Container(
              key: Key(i.toString()),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                children: List.generate(9, (int j) {
                  int bigRow = (i / 3).floor();
                  int bigCol = i % 3;

                  int smallRow = (j / 3).floor();
                  int smallCol = j % 3;

                  Cell cell = new Cell(
                    bigCol * 3 + smallCol,
                    bigRow * 3 + smallRow,
                  );

                  SudokuField field = sudoku.getField(cell);

                  return Card(
                    key: Key(cell.toString()),
                    child: LayoutBuilder(
                      builder: (context, constraints) => field.valueSet
                          ? Center(
                              child: Text(
                                '${field.value}',
                                style: TextStyle(
                                    fontSize: constraints.maxWidth * 0.75),
                              ),
                            )
                          : ElevatedButton(
                              child: Container(),
                              style: ElevatedButton.styleFrom(
                                primary: cell.equal(selectedCell)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryVariant
                                    : Theme.of(context).cardColor,
                              ),
                              onPressed: () => setSelectCell(cell),
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

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

                  return GridCell(
                    key: Key(cell.toString()),
                    selected: cell.equal(selectedCell),
                    cell: cell,
                    field: sudoku.getField(cell),
                    setSelectCell: setSelectCell,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final bool selected;
  final SudokuField field;
  final Cell cell;
  final Function(Cell) setSelectCell;

  const GridCell({
    Key? key,
    required this.selected,
    required this.field,
    required this.cell,
    required this.setSelectCell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: LayoutBuilder(builder: (context, constraints) {
        if (field.valueSet)
          return Center(
            child: Text(
              '${field.value}',
              style: TextStyle(fontSize: constraints.maxWidth * .75),
            ),
          );

        return ElevatedButton(
          child: Container(
            child: Column(
              children: List.generate(
                3,
                (i) => Row(
                  children: List.generate(
                    3,
                    (j) {
                      int value = i * 3 + j + 1;
                      return Expanded(
                        child: Center(
                          child: field.posibilities[value] == true
                              ? Text(
                                  value.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.color,
                                    fontSize: constraints.maxWidth * .4,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                        ),
                      );
                    },
                  ),
                ),
              ).toList(),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: selected
                ? Theme.of(context).colorScheme.primaryVariant
                : Theme.of(context).cardColor,
          ),
          onPressed: () => setSelectCell(cell),
        );
      }),
    );
  }
}

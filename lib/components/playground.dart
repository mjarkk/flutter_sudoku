import 'package:flutter/material.dart';
import '../logic/sudoku.dart';

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
    BorderRadius cellBorderRadius = BorderRadius.circular(6);

    return LayoutBuilder(builder: (context, constraints) {
      if (field.value != null)
        return Container(
          decoration: BoxDecoration(
            borderRadius: cellBorderRadius,
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: Text(
              '${field.value}',
              style: TextStyle(fontSize: constraints.maxWidth * .75),
            ),
          ),
        );

      double posibilityFontSize =
          constraints.maxWidth < 50 ? constraints.maxWidth * .3 : 15;

      return ElevatedButton(
        child: Container(
          constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
          child: Column(
            children: List.generate(3, (i) {
              int valueOffset = i * 3 + 1;
              return Expanded(
                child: Row(
                  children: List.generate(
                    3,
                    (j) {
                      int value = valueOffset + j;
                      return _Possibility(
                        value: field.posibilities[value] == true ? value : null,
                        fontSize: posibilityFontSize,
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          primary: selected
              ? Theme.of(context).colorScheme.primaryVariant
              : Theme.of(context).cardColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: cellBorderRadius),
        ),
        onPressed: () => setSelectCell(cell),
      );
    });
  }
}

class _Possibility extends StatelessWidget {
  final int? value;
  final double fontSize;
  const _Possibility({Key? key, this.value, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: value != null
            ? Text(
                value.toString(),
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption?.color,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
      ),
    );
  }
}

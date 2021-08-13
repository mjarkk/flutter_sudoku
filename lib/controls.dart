import 'package:flutter/material.dart';
import 'sudoku.dart';

class Controls extends StatelessWidget {
  final Function(int) onNumberSelection;
  final Function(int) onNumberConfirm;
  final SudokuField field;
  final Cell? cell;

  Controls({
    required this.onNumberSelection,
    required this.onNumberConfirm,
    required this.field,
    required this.cell,
  });

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(9, (int j) {
              int value = j + 1;
              bool active = field.posibilities[value] ?? false;
              Key key = Key(j.toString());

              return _ControlValue(
                active: active,
                key: key,
                value: value,
                onNumberSelection:
                    cell != null ? () => onNumberSelection(value) : null,
                onNumberConfirm: () => onNumberConfirm(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ControlValue extends StatelessWidget {
  final bool active;
  final int value;
  final Function()? onNumberSelection;
  final Function() onNumberConfirm;

  const _ControlValue({
    Key? key,
    required this.active,
    required this.value,
    required this.onNumberSelection,
    required this.onNumberConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    ThemeData theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: active ? theme.colorScheme.primary : theme.cardColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: active && onNumberSelection != null
                        ? darkMode
                            ? Colors.black
                            : Colors.white
                        : darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
              onPressed:
                  onNumberSelection != null ? () => onNumberSelection!() : null,
            ),
            (active && onNumberSelection != null)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: onNumberConfirm,
                      child: Icon(Icons.check),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

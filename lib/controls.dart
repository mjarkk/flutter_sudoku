import 'package:flutter/material.dart';
import 'sudoku.dart';

enum ControlsLayout {
  horizontalLine,
  verticalLine,
  block,
}

class Controls extends StatelessWidget {
  final Function(int) onNumberSelection;
  final Function(int) onNumberConfirm;
  final SudokuField field;
  final Cell? cell;
  final ControlsLayout layout;

  const Controls({
    required this.onNumberSelection,
    required this.onNumberConfirm,
    required this.field,
    required this.cell,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: layout == ControlsLayout.verticalLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10).copyWith(top: 0),
            child: Text(
              'Select posiblities',
              style: theme.textTheme.caption,
            ),
          ),
          layout == ControlsLayout.verticalLine
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 150,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(9, (int j) {
                      int value = j + 1;
                      bool active = field.posibilities[value] ?? false;
                      Key key = Key(j.toString());

                      return _ControlValue(
                        active: active,
                        key: key,
                        value: value,
                        onNumberSelection: cell != null
                            ? () => onNumberSelection(value)
                            : null,
                        onNumberConfirm: () => onNumberConfirm(value),
                        layout: layout,
                      );
                    }).toList(),
                  ))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(9, (int j) {
                    int value = j + 1;
                    bool active = field.posibilities[value] ?? false;
                    Key key = Key(j.toString());

                    return Expanded(
                      key: key,
                      child: _ControlValue(
                        active: active,
                        value: value,
                        onNumberSelection: cell != null
                            ? () => onNumberSelection(value)
                            : null,
                        onNumberConfirm: () => onNumberConfirm(value),
                        layout: layout,
                      ),
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
  final ControlsLayout layout;

  _ControlValue({
    Key? key,
    required this.active,
    required this.value,
    required this.onNumberSelection,
    required this.onNumberConfirm,
    required this.layout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    ThemeData theme = Theme.of(context);

    List<Widget> buttons = [
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
              padding: layout == ControlsLayout.horizontalLine
                  ? EdgeInsets.only(top: 10)
                  : EdgeInsets.only(left: 10),
              child: ElevatedButton(
                onPressed: onNumberConfirm,
                child: Icon(Icons.check),
              ),
            )
          : Container(),
    ];

    return Container(
      padding: layout == ControlsLayout.verticalLine
          ? EdgeInsets.only(top: 4, bottom: 4)
          : EdgeInsets.only(left: 4, right: 4),
      child: layout == ControlsLayout.horizontalLine
          ? Column(
              children: buttons,
            )
          : Row(
              children: buttons,
            ),
    );
  }
}

import 'package:flutter/material.dart';
import '../logic/sudoku.dart';

enum ControlsLayout {
  horizontalLine,
  verticalLine,
}

const double ControlsMinHeight = 70;
const double ControlsMinWidth = 130;

class Controls extends StatelessWidget {
  final Function(int) onNumberSelection;
  final Function(int) onNumberConfirm;
  final SudokuField field;
  final Cell? cell;
  final ControlsLayout layout;
  final bool small;

  const Controls({
    required this.onNumberSelection,
    required this.onNumberConfirm,
    required this.field,
    required this.cell,
    required this.layout,
    required this.small,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(small ? 6 : 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: ControlsMinWidth,
              minHeight: ControlsMinHeight,
            ),
            child: layout == ControlsLayout.verticalLine
                ? Column(
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
                        small: small,
                      );
                    }).toList(),
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    bool expandControls = constraints.maxWidth < 700;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(9, (int j) {
                        int value = j + 1;
                        bool active = field.posibilities[value] ?? false;
                        Key key = Key(j.toString());

                        Widget res = _ControlValue(
                          key: key,
                          active: active,
                          value: value,
                          onNumberSelection: cell != null
                              ? () => onNumberSelection(value)
                              : null,
                          onNumberConfirm: () => onNumberConfirm(value),
                          layout: layout,
                          small: small,
                        );

                        return expandControls
                            ? Expanded(key: key, child: res)
                            : res;
                      }).toList(),
                    );
                  }),
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
  final bool small;

  const _ControlValue({
    Key? key,
    required this.active,
    required this.value,
    required this.onNumberSelection,
    required this.onNumberConfirm,
    required this.layout,
    required this.small,
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
        child: Text(
          value.toString(),
          style: TextStyle(
            fontSize: small ? 15 : 20,
            color: active && onNumberSelection != null
                ? darkMode
                    ? Colors.black
                    : Colors.white
                : darkMode
                    ? Colors.white
                    : Colors.black,
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
                child: Icon(
                  Icons.check,
                  size: small ? 15 : 20,
                ),
              ),
            )
          : Container(),
    ];

    return Container(
      padding: layout == ControlsLayout.verticalLine
          ? EdgeInsets.symmetric(vertical: small ? 2 : 4)
          : EdgeInsets.symmetric(horizontal: small ? 2 : 4),
      child: layout == ControlsLayout.horizontalLine
          ? Column(children: buttons)
          : Row(children: buttons),
    );
  }
}

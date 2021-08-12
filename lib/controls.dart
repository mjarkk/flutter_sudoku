import 'package:flutter/material.dart';
import 'sudoku.dart';
import 'playground.dart';

class Controls extends StatelessWidget {
  final Function(int) onNumberSelection;
  final SudokuField field;
  final Cell? cell;

  Controls({
    required this.onNumberSelection,
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
            children: List.generate(9, (int j) {
              bool active = field.posibilities[j + 1] ?? false;
              Key key = Key(j.toString());

              return _ControlButton(
                active: active,
                key: key,
                value: j + 1,
                onNumberSelection: cell != null ? onNumberSelection : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final bool active;
  final int value;
  final Function(int)? onNumberSelection;
  static const _duration = Duration(milliseconds: 100);

  const _ControlButton({
    Key? key,
    required this.active,
    required this.value,
    required this.onNumberSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Expanded(
      key: key,
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: TweenAnimationBuilder(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: TweenAnimationBuilder(
                  tween: ColorTween(
                    begin: null,
                    end: active && onNumberSelection != null
                        ? theme.buttonColor
                        : theme.textTheme.bodyText1?.color,
                  ),
                  duration: _duration,
                  builder: (_, Color? color, __) {
                    return Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: color,
                      ),
                    );
                  }),
            ),
            tween: ColorTween(
              begin: active ? theme.colorScheme.primary : theme.cardColor,
              end: active ? theme.colorScheme.primary : theme.cardColor,
            ),
            duration: _duration,
            builder: (BuildContext context, Color? color, Widget? child) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color,
                ),
                child: child,
                onPressed: onNumberSelection != null
                    ? () => onNumberSelection!(value)
                    : null,
              );
            }),
      ),
    );
  }
}

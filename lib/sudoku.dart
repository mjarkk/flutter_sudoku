class Sudoku {
  List<List<SudokuField>> fields = [];

  Sudoku() {
    var contents = [
      "9 4" + "3  " + "1  ",
      "   " + " 1 " + "9  ",
      " 73" + "   " + "  8",
      //
      "3  " + "8 9" + "   ",
      " 8 " + "147" + " 9 ",
      "   " + "2 3" + "  4",
      //
      "5  " + "   " + "26 ",
      "  2" + " 3 " + "   ",
      "  9" + "  5" + "3 7",
    ];

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        String number = contents[i][j];

        if (fields.length == 0 || fields[fields.length - 1].length == 9) {
          fields.add([]);
        }

        fields[fields.length - 1].add(number == ' '
            ? new SudokuField()
            : new SudokuField.withValue(int.parse(number)));
      }
    }
  }

  SudokuField getField(Cell cell) {
    return fields[cell.y][cell.x];
  }

  setFieldValue(Cell cell, int value) {
    if (!cell.placeholder) fields[cell.y][cell.x].setValue(value);
  }

  toggleFieldPosibility(Cell cell, int value) {
    if (!cell.placeholder) fields[cell.y][cell.x].togglePosibility(value);
  }
}

class SudokuField {
  bool valueSet = false;
  int? value;
  Map<int, bool> posibilities = {};

  SudokuField();
  SudokuField.withValue(int value) {
    setValue(value);
  }

  setValue(int value) {
    assert(value > 0);
    assert(value <= 9);

    this.value = value;
    valueSet = true;
  }

  togglePosibility(int value) {
    bool? prevValue = posibilities[value];
    posibilities[value] = prevValue == null ? true : !prevValue;
  }
}

class Cell {
  late final int x;
  late final int y;
  late final bool placeholder;

  Cell(this.x, this.y) {
    placeholder = false;
  }
  Cell.placeholder() {
    x = 0;
    y = 0;
    placeholder = true;
  }

  bool equal(Cell? other) {
    if (other == null) {
      return false;
    }

    return x == other.x && y == other.y;
  }

  @override
  String toString() {
    return x.toString() + '-' + y.toString();
  }
}

class Sudoku {
  List<List<SudokuField>> fields = [];

  Sudoku() {
    List<String> contents = [
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

    // List<String> contents = [
    //   "954" + "382" + "176",
    //   "826" + "714" + "935",
    //   "173" + "596" + "428",
    //   //
    //   "341" + "869" + "752",
    //   "285" + "1 7" + "693",
    //   "697" + "253" + "814",
    //   //
    //   "538" + "471" + "269",
    //   "762" + "938" + "541",
    //   "419" + "625" + "387",
    // ];

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
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
    if (cell.placeholder) return;

    var mapFn = (_CellAndField v) {
      fields[v.cell.y][v.cell.x].setPosibility(value, false);
    };

    getArea(cell).forEach(mapFn);
    getRow(cell.y).forEach(mapFn);
    getColumn(cell.x).forEach(mapFn);

    fields[cell.y][cell.x].setValue(value);
  }

  bool canSetFieldValue(Cell cell, int value) {
    if (cell.placeholder) return false;

    var testFn =
        (_CellAndField v) => v.field.value != null && v.field.value == value;

    // Check sudoku area
    if (getArea(cell).any(testFn)) return false;
    // Check row and column
    if (getRow(cell.y).any(testFn)) return false;
    if (getColumn(cell.x).any(testFn)) return false;

    return true;
  }

  Set<_CellAndField> getColumn(int x) {
    Set<_CellAndField> res = Set();
    for (int y = 0; y < 9; y++) {
      res.add(_CellAndField(Cell(x, y), fields[y][x]));
    }
    return res;
  }

  Set<_CellAndField> getRow(int y) {
    Set<_CellAndField> res = Set();
    for (int x = 0; x < 9; x++) {
      res.add(_CellAndField(Cell(x, y), fields[y][x]));
    }
    return res;
  }

  Set<_CellAndField> getArea(Cell cell) {
    Set<_CellAndField> res = Set();
    if (cell.placeholder) return res;

    int baseX = cell.x - (cell.x % 3);
    int baseY = cell.y - (cell.y % 3);

    for (int yOffset = 0; yOffset < 3; yOffset++) {
      int y = baseY + yOffset;
      List<SudokuField> row = fields[y];
      for (int xOffset = 0; xOffset < 3; xOffset++) {
        int x = baseX + xOffset;
        res.add(_CellAndField(Cell(x, y), row[x]));
      }
    }

    return res;
  }

  toggleFieldPosibility(Cell cell, int value) {
    if (!cell.placeholder) fields[cell.y][cell.x].togglePosibility(value);
  }
}

class _CellAndField {
  final Cell cell;
  final SudokuField field;

  _CellAndField(this.cell, this.field);
}

class SudokuField {
  int? value;

  // map with 1..9
  Map<int, bool> posibilities = {};

  SudokuField();
  SudokuField.withValue(int value) {
    setValue(value);
  }

  setValue(int value) {
    assert(value > 0);
    assert(value <= 9);

    this.value = value;
  }

  togglePosibility(int value) {
    bool? prevValue = posibilities[value];
    posibilities[value] = prevValue == null ? true : !prevValue;
  }

  setPosibility(int value, bool to) {
    posibilities[value] = to;
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

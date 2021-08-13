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
    if (!cell.placeholder) fields[cell.y][cell.x].setValue(value);
  }

  bool canSetFieldValue(Cell cell, int value) {
    // Check cell
    if (cell.placeholder) return false;

    // Check sudoku area
    if (getAreaValues(cell).contains(value)) return false;

    // Check row and column
    if (getColumnValues(cell.x).contains(value)) return false;
    if (getRowValues(cell.y).contains(value)) return false;

    return true;
  }

  Set<SudokuField> getColumn(int x) {
    Set<SudokuField> res = Set();
    for (List<SudokuField> row in fields) {
      res.add(row[x]);
    }
    return res;
  }

  Set<int> getColumnValues(int x) {
    Set<int> res = Set();
    for (List<SudokuField> row in fields) {
      SudokuField field = row[x];
      if (field.value != null) res.add(field.value!);
    }
    return res;
  }

  Set<SudokuField> getRow(int y) {
    Set<SudokuField> res = Set();
    for (SudokuField field in fields[y]) {
      res.add(field);
    }
    return res;
  }

  Set<int> getRowValues(int y) {
    Set<int> res = Set();
    for (SudokuField field in fields[y]) {
      if (field.value != null) res.add(field.value!);
    }
    return res;
  }

  Set<SudokuField> getArea(Cell cell) {
    Set<SudokuField> res = Set();
    if (cell.placeholder) return res;

    int baseX = cell.x - (cell.x % 3);
    int baseY = cell.y - (cell.y % 3);

    for (int yOffset = 0; yOffset < 3; yOffset++) {
      List<SudokuField> row = fields[baseY + yOffset];
      for (int xOffset = 0; xOffset < 3; xOffset++) {
        res.add(row[baseX + xOffset]);
      }
    }

    return res;
  }

  Set<int> getAreaValues(Cell cell) {
    Set<int> res = Set();
    if (cell.placeholder) return res;

    int baseX = cell.x - (cell.x % 3);
    int baseY = cell.y - (cell.y % 3);

    for (int yOffset = 0; yOffset < 3; yOffset++) {
      List<SudokuField> row = fields[baseY + yOffset];
      for (int xOffset = 0; xOffset < 3; xOffset++) {
        SudokuField field = row[baseX + xOffset];
        if (field.value != null) {
          res.add(field.value!);
        }
      }
    }

    return res;
  }

  toggleFieldPosibility(Cell cell, int value) {
    if (!cell.placeholder) fields[cell.y][cell.x].togglePosibility(value);
  }
}

class SudokuField {
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

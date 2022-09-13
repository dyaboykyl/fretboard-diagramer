class FretPosition {
  final int fret;
  final int string;

  FretPosition({required this.fret, required this.string});

  @override
  operator ==(other) => other is FretPosition && other.fret == fret && other.string == string;

  @override
  int get hashCode => Object.hash(fret, string);

  @override
  String toString() {
    return "string=$string, fret=$fret";
  }
}

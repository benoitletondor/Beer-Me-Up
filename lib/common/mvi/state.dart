abstract class State {
  @override
  bool operator ==(Object other) =>
      identical(this, other) || runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}
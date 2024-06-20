enum Aspect { N, NE, E, SE, S, SW, W, NW }

Aspect enumFromString(String value) {
  return Aspect.values.firstWhere((element) => element.toString() == value,
      orElse: () => throw ArgumentError("Unknown enum value: $value"));
}

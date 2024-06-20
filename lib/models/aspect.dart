enum Aspect { N, NE, E, SE, S, SW, W, NW }

// Might want to reacftor this approah in future re/ .split('.').last but works fine for now
Aspect enumFromString(String value) {
  return Aspect.values.firstWhere((element) {
    return element.toString().split('.').last == value;
  }, orElse: () => throw ArgumentError("Unknown enum value: $value"));
}

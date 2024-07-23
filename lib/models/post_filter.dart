import 'package:snowpack/models/aspect.dart';

class PostFilter {
  final int? elevationFilter;
  final Aspect? aspectFilter;
  final int? temperatureFilter;

  PostFilter({this.elevationFilter, this.aspectFilter, this.temperatureFilter});

  PostFilter copyWith({
    int? elevationFilter,
    Aspect? aspectFilter,
    int? temperatureFilter,
  }) {
    return PostFilter(
      elevationFilter: elevationFilter ?? this.elevationFilter,
      aspectFilter: aspectFilter,
      temperatureFilter: temperatureFilter ?? this.temperatureFilter,
    );
  }
}

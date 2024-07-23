import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post_filter.dart';

class PostFilterNotifier extends StateNotifier<PostFilter> {
  PostFilterNotifier({postFilters}) : super(postFilters);

  void setElevationFilter(int elevation) {
    state = state.copyWith(elevationFilter: elevation);
    // Optionally, you might want to fetch posts with the new elevation filter here
  }

  Future<bool> setAspectFilter(Aspect aspect) {
    state = state.copyWith(aspectFilter: aspect);
    return Future.value(true);
  }

  void setTemperatureFilter(int temperature) {
    state = state.copyWith(temperatureFilter: temperature);
  }

  void clearFilters() {
    state = state.copyWith(
        elevationFilter: 0, aspectFilter: null, temperatureFilter: 0);
  }
}

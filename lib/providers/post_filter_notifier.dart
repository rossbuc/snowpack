import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post_filter.dart';

final postFilterProvider =
    StateNotifierProvider<PostFilterNotifier, PostFilter>(
  (ref) => PostFilterNotifier(
    postFilters: PostFilter(
      elevationFilter: 0,
      aspectFilter: null,
      temperatureFilter: 0,
    ),
  ),
);

class PostFilterNotifier extends StateNotifier<PostFilter> {
  PostFilterNotifier({postFilters}) : super(postFilters);

  void setElevationFilter(int elevation) {
    state = state.copyWith(elevationFilter: elevation);
    // Optionally, you might want to fetch posts with the new elevation filter here
  }

  void setAspectFilter(Aspect aspect) {
    state = state.copyWith(aspectFilter: aspect);
  }

  void setTemperatureFilter(int temperature) {
    state = state.copyWith(temperatureFilter: temperature);
  }

  void clearFilters() {
    state = state.reset();
  }
}

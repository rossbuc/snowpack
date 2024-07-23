import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/widgets/home_page_app_bar.dart';

class ElevationDropdown extends ConsumerWidget {
  const ElevationDropdown({
    super.key,
    required this.postService,
  });

  final PostService postService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postFilters = ref.watch(postFilterProvider);
    return DropdownButton<int>(
      value: postFilters.elevationFilter,
      onChanged: (value) {
        if (value != null) {
          ref.read(postFilterProvider.notifier).setElevationFilter(value);
          postService.getPostsWithCurrentFilters(postFilters);
          print("Selected Elevation: $value ft");
        }
      },
      items: List.generate(
        110,
        (index) => DropdownMenuItem<int>(
          value: index * 100,
          child: Text('${index * 100} m'),
        ),
      ),
    );
  }
}

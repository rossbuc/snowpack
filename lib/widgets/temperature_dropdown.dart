import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/widgets/home_page_app_bar.dart';

class TemperatureDropdown extends ConsumerWidget {
  const TemperatureDropdown({
    super.key,
    required this.postService,
  });

  final PostService postService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var postFilters = ref.watch(postFilterProvider);
    return DropdownButton<int>(
      hint: Text("Select Temperature Range"),
      value: postFilters.temperatureFilter,
      onChanged: (value) {
        if (value != null) {
          ref.read(postFilterProvider.notifier).setTemperatureFilter(value);
          postService.getPostsWithCurrentFilters(postFilters);
          print("Selected Temperature: $value degrees");
        }
      },
      items: List.generate(
        10,
        (index) => DropdownMenuItem<int>(
          value: (index - 5) * 5,
          child: Text('${(index - 5) * 5} degrees'),
        ),
      ),
    );
  }
}

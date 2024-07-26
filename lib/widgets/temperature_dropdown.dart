import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/providers/post_filter_notifier.dart';

class TemperatureDropdown extends ConsumerWidget {
  const TemperatureDropdown({
    super.key,
    required this.postService,
  });

  final PostService postService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var postFilters = ref.watch(postFilterProvider);
    postService.getPostsWithCurrentFilters(postFilters);
    return DropdownButton<int>(
      hint: const Text("Select Temperature"),
      value: postFilters.temperatureFilter,
      onChanged: (value) {
        if (value != null) {
          ref.read(postFilterProvider.notifier).setTemperatureFilter(value);
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

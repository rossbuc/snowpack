import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/widgets/home_page_app_bar.dart';

class AspectDropdown extends ConsumerWidget {
  final PostService postService;
  final List<Aspect> aspects;
  final Aspect? initialAspectValue;

  const AspectDropdown({
    super.key,
    required this.postService,
    required this.aspects,
    required this.initialAspectValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var postFilters = ref.watch(postFilterProvider);
    return DropdownButton<Aspect>(
      hint: Text('Select Aspect'),
      value: initialAspectValue,
      onChanged: (value) {
        if (value != null) {
          ref.read(postFilterProvider.notifier).setAspectFilter(value);
          postService.getPostsWithCurrentFilters(postFilters);
          print("Selected Aspect: ${value.toString().split('.').last}");
        }
      },
      items: aspects.map((Aspect aspect) {
        return DropdownMenuItem<Aspect>(
          value: aspect,
          child: Text(aspect.toString().split('.').last),
        );
      }).toList(),
    );
  }
}

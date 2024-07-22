import 'package:flutter/material.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';

class AspectDropdown extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DropdownButton<Aspect>(
      hint: Text('Select Aspect'),
      value: initialAspectValue,
      onChanged: (value) {
        if (value != null) {
          postService.setAspectFilter(value);
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

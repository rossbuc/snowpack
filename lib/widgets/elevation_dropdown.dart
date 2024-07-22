import 'package:flutter/material.dart';
import 'package:snowpack/services/post_service.dart';

class ElevationDropdown extends StatelessWidget {
  const ElevationDropdown({
    super.key,
    required this.postService,
    required this.initialElevationValue,
  });

  final PostService postService;
  final int initialElevationValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: initialElevationValue,
      onChanged: (value) {
        if (value != null) {
          postService.setElevationFilter(value);
          print("Selected Elevation: $value ft");
        }
      },
      items: List.generate(
        110,
        (index) => DropdownMenuItem<int>(
          value: index * 100,
          child: Text('${index * 100} ft'),
        ),
      ),
    );
  }
}

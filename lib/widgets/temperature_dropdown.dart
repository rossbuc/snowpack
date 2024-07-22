import 'package:flutter/material.dart';
import 'package:snowpack/services/post_service.dart';

class TemperatureDropdown extends StatelessWidget {
  const TemperatureDropdown({
    super.key,
    required this.postService,
    required this.initialTemperatureValue,
  });

  final PostService postService;
  final int initialTemperatureValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      hint: Text("Select Temperature Range"),
      value: initialTemperatureValue,
      onChanged: (value) {
        if (value != null) {
          postService.setTemperatureFilter(value);
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

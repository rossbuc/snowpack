import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/views/post_list.dart';

class Feed extends ConsumerWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final postService = ref.read(postServiceProvider.notifier);

    void settingsPressed() {
      print("Settings Pressed");
      _showFilterMenu(context, postService);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            // expandedHeight: 120,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 4.0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  splashColor: colorScheme.secondary.withOpacity(0.5),
                  onTap: _onLogoTap,
                  child: SizedBox(
                    width: 50, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/SnowPack Logo Symbol.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.gear_alt),
                  onPressed: () {
                    settingsPressed();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PopupMenuButton<String>(
                  icon: const Icon(CupertinoIcons.line_horizontal_3),
                  onSelected: (String result) {
                    postService.sortPosts(result);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'time',
                      child: Text('Sort by Time'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'location',
                      child: Text('Sort by Location'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const PostList(),
        ],
      ),
    );
  }

  void _onLogoTap() {
    print("Logo Pressed");
  }

  void _showFilterMenu(BuildContext context, PostService postService) {
    final initialElevationValue = postService.currentElevationFilter ?? 0;
    final initialAspectValue = postService.currentAspectFilter;
    final initialTemperatureValue = postService.currentTemperatureFilter ?? 0;

    // Aspect Filter Dropdown
    const aspects = Aspect.values;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Posts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Elevation Filter
              DropdownButton<int>(
                value: initialElevationValue,
                onChanged: (value) {
                  if (value != null) {
                    postService.setElevationFilter(value);
                    print("Selected Elevation: $value ft");
                  }
                },
                items: List.generate(
                  110, // Adjust based on the range of elevation you want to display
                  (index) => DropdownMenuItem<int>(
                    value: index * 100,
                    child: Text('${index * 100} ft'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Aspect Filter
              DropdownButton<Aspect>(
                hint: Text('Select Aspect'),
                value: initialAspectValue,
                onChanged: (value) {
                  if (value != null) {
                    postService.setAspectFilter(value);
                    print(
                        "Selected Aspect: ${value.toString().split('.').last}");
                  }
                },
                items: aspects.map((Aspect aspect) {
                  return DropdownMenuItem<Aspect>(
                    value: aspect,
                    child: Text(aspect.toString().split('.').last),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Temperature Filter
              DropdownButton<int>(
                hint: Text("Select Temperature Range"),
                value: initialTemperatureValue,
                onChanged: (value) {
                  if (value != null) {
                    postService.setTemperatureFilter(value);
                    print("Selected Temperature: $value degrees");
                  }
                },
                items: List.generate(
                  10, // Adjust based on the range of temperature you want to display
                  (index) => DropdownMenuItem<int>(
                    value: (index - 5) * 10,
                    child: Text('${(index - 5) * 10} degrees'),
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

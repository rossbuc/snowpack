import 'package:flutter/material.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/widgets/aspect_dropdown.dart';
import 'package:snowpack/widgets/elevation_dropdown.dart';
import 'package:snowpack/widgets/logo_button.dart';
import 'package:snowpack/widgets/settings_button.dart';
import 'package:snowpack/widgets/sort_button.dart';
import 'package:snowpack/widgets/temperature_dropdown.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({
    super.key,
    required this.context,
    required this.colorScheme,
    required this.postService,
  });

  final BuildContext context;
  final ColorScheme colorScheme;
  final PostService postService;

  @override
  Widget build(BuildContext context) {
    void _showFilterMenu(BuildContext context, PostService postService) {
      final initialElevationValue = postService.currentElevationFilter ?? 0;
      final initialAspectValue = postService.currentAspectFilter;
      final initialTemperatureValue = postService.currentTemperatureFilter ?? 0;

      const aspects = Aspect.values;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filter Posts'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevationDropdown(
                    postService: postService,
                    initialElevationValue: initialElevationValue),
                SizedBox(height: 20),
                AspectDropdown(
                    postService: postService,
                    aspects: aspects,
                    initialAspectValue: initialAspectValue),
                SizedBox(height: 20),
                TemperatureDropdown(
                    postService: postService,
                    initialTemperatureValue: initialTemperatureValue),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  postService.clearFilters();
                  Navigator.of(context).pop();
                },
                child: const Text("Reset"),
              ),
            ],
          );
        },
      );
    }

    void settingsPressed() {
      print("Settings Pressed");
      _showFilterMenu(context, postService);
    }

    return SliverAppBar(
      floating: true,
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
      leading: LogoButton(context: context, colorScheme: colorScheme),
      actions: [
        SettingsButton(settingsPressed: settingsPressed),
        SortButton(postService: postService),
      ],
    );
  }
}

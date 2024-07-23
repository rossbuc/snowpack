import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post_filter.dart';
import 'package:snowpack/providers/post_filter_notifier.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/widgets/aspect_dropdown.dart';
import 'package:snowpack/widgets/elevation_dropdown.dart';
import 'package:snowpack/widgets/logo_button.dart';
import 'package:snowpack/widgets/settings_button.dart';
import 'package:snowpack/widgets/sort_button.dart';
import 'package:snowpack/widgets/temperature_dropdown.dart';

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

class HomePageAppBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    void _showFilterMenu(BuildContext context, PostService postService) {
      var postFilters = ref.watch(postFilterProvider);
      var postFilterNotifier = ref.read(postFilterProvider.notifier);

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
                    initialElevationValue: postFilters.elevationFilter ?? 0),
                SizedBox(height: 20),
                AspectDropdown(
                    postService: postService,
                    aspects: aspects,
                    initialAspectValue: postFilters.aspectFilter),
                SizedBox(height: 20),
                TemperatureDropdown(
                    postService: postService,
                    initialTemperatureValue:
                        postFilters.temperatureFilter ?? 0),
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
                  postFilterNotifier.clearFilters();
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

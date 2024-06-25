import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/views/post_list.dart';

class Feed extends ConsumerWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final postService = ref.read(postServiceProvider.notifier);

    void _settingsPressed() {
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
                    _settingsPressed();
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
    final initialValue = postService.currentElevationFilter ?? 0;

    showMenu<int>(
      context: context,
      position:
          RelativeRect.fromLTRB(0, 100, 0, 0), // Adjust position as needed
      items: List.generate(
        110, // Adjust based on the range of elevation you want to display
        (index) => PopupMenuItem<int>(
          value: index * 100,
          child: Text('${index * 100} ft'),
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
      initialValue: initialValue,
    ).then((value) {
      if (value != null) {
        postService.setElevationFilter(value);
        print("Selected Elevation: $value ft");
      }
    });
  }
}

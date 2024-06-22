import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/views/post_list.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
                    _sortPosts(result);
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

  void _sortPosts(String criteria) {
    if (criteria == 'time') {
      print("Sorting by Time");
      // Add your sorting logic here
    } else if (criteria == 'location') {
      print("Sorting by Location");
      // Add your sorting logic here
    }
  }
}

void settingsPressed() {
  print("Settings Pressed");
}

void _onLogoTap() {
  print("Logo Pressed");
}

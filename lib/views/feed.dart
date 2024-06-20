import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/views/post_list.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [colorScheme.primary, colorScheme.secondary],
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //   ),
      //   elevation: 4.0,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 4),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(16),
      //       child: InkWell(
      //         borderRadius: BorderRadius.circular(16),
      //         splashColor: colorScheme.secondary.withOpacity(0.5),
      //         onTap: _onLogoTap,
      //         child: SizedBox(
      //           width: 50, // Adjust the width as needed
      //           height: 50, // Adjust the height as needed
      //           child: Align(
      //             alignment: Alignment.center,
      //             child: Image.asset(
      //               "assets/images/SnowPack Logo Symbol.png",
      //               fit: BoxFit.contain,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: IconButton(
      //         icon: const Icon(CupertinoIcons.gear_alt),
      //         onPressed: () {
      //           settingsPressed();
      //         },
      //       ),
      //     )
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
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
              )
            ],
          )
        ],
      ),
    );
  }
}

void settingsPressed() {
  print("Settings Pressed");
}

void _onLogoTap() {
  print("Logo Pressed");
}

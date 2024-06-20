import 'package:flutter/material.dart';

class UserHomepage extends StatelessWidget implements PreferredSizeWidget {
  // callback functions for if the app bar gets moved to different component
  // then when you call an instnace of the "UserAppBar" you should give it handlers for when the settings button and the backbutton are pressed
  // final VoidCallback onSettingsPressed;
  // final VoidCallback? onBackPressed; // Optional

  const UserHomepage({
    super.key,
    // required this.username,
    // required this.onSettingsPressed,
    // this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the default back button
      leading: onBackPressed != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            )
          : null,
      title: const Text(
        "username", // TODO : Replace with actual username
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsPressed,
        ),
      ],
    );
  }

  void onSettingsPressed() {
    print("settings pressed");
  }

  void onBackPressed() {
    print("back pressed");
  }
}

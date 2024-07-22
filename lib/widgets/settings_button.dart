import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.settingsPressed,
  });

  final void Function() settingsPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: IconButton(
        icon: const Icon(CupertinoIcons.gear_alt),
        onPressed: settingsPressed,
      ),
    );
  }
}

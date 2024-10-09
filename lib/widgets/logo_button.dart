import 'package:flutter/material.dart';

class LogoButton extends StatelessWidget {
  const LogoButton({
    super.key,
    required this.context,
    required this.colorScheme,
  });

  final BuildContext context;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    void onLogoTap() {
      print("Logo Pressed");
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: colorScheme.secondary.withOpacity(0.5),
          onTap: onLogoTap,
          child: SizedBox(
            width: 50,
            height: 50,
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
    );
  }
}

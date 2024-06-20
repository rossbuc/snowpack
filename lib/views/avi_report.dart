import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AviReport extends StatelessWidget {
  const AviReport({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.onInverseSurface, colorScheme.surfaceBright],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4.0,
        title: Text('Avalanche Report'),
        titleTextStyle: TextStyle(
            color: colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0), // Adjust the padding as needed(8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.line_horizontal_3),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

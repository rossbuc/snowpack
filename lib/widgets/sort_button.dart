import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snowpack/services/post_service.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.postService,
  });

  final PostService postService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PopupMenuButton<String>(
        icon: const Icon(CupertinoIcons.line_horizontal_3),
        onSelected: (String result) {
          postService.sortPosts(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
    );
  }
}

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
      padding: const EdgeInsets.only(left: 4, right: 12),
      child: PopupMenuButton<String>(
        icon: const Icon(CupertinoIcons.sort_down),
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

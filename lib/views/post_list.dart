import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postServiceProvider);
    print("This is the list of posts: $posts");
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(posts[index].description),
          subtitle: Text(
              'Coordinates: (${posts[index].xcoordinate}, ${posts[index].ycoordinate})'),
        );
      },
    );
  }
}

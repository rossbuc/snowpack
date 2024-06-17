import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/user.dart';
import 'package:snowpack/views/post_tile.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postServiceProvider);
    final userService = ref.read(userServiceProvider.notifier);
    print("This is the list of posts: $posts");
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final user = userService.getUserById(posts[index].userId);
        return PostTile(post: posts[index], user: user!);
      },
    );
  }
}

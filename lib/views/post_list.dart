import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/views/post_tile.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  // Thinking that we could wrap this in a Feed widget which will have the app bar then the post_list
  // reason being that we are probably going to want to move the app bar into components anyway as its not gonna be the same for every nav route

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postServiceProvider);
    final userService = ref.read(userServiceProvider.notifier);
    print("This is the list of posts: $posts");
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: posts.length,
        (context, index) {
          final user = userService.getUserById(posts[index].userId);
          return PostTile(post: posts[index], user: user!);
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/views/post_tile.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  // SliverToBoxAdapter, potential solution for safe scroll view

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postServiceProvider);
    final userService = ref.read(userServiceProvider.notifier);
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

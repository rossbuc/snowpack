import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/views/post_list.dart';
import 'package:snowpack/widgets/home_page_app_bar.dart';
import 'package:snowpack/providers/post_filter_notifier.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollPosition = 0;
  double _scrollDownStartPosition = 0;
  bool _isAppBarVisible = true;
  bool _holdSafeArea = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentPosition = _scrollController.position.pixels;
    final safePadding = MediaQuery.of(context).padding.top;
    final appBarHeight = AppBar().preferredSize.height;
    final appBarHeightPlusStatusBarHeight = appBarHeight + safePadding;

    final isScrollingUp = _previousScrollPosition > currentPosition;
    final isScrollingDown = _previousScrollPosition < currentPosition;

    // When starting to scroll up, record the start position
    if (isScrollingUp) {
      _scrollDownStartPosition = currentPosition;
    }

    // Calculate if the AppBar should be visible
    final isAppBarVisible =
        currentPosition < appBarHeightPlusStatusBarHeight || isScrollingUp;

    // Determine if we should hold off rendering the SafeArea
    if (isScrollingDown && currentPosition > appBarHeightPlusStatusBarHeight) {
      if (currentPosition - _scrollDownStartPosition > appBarHeight) {
        setState(() {
          _holdSafeArea = false;
        });
      } else {
        setState(() {
          _holdSafeArea = true;
        });
      }
    }

    // Update the AppBar visibility if it has changed
    if (_isAppBarVisible != isAppBarVisible) {
      setState(() {
        _isAppBarVisible = isAppBarVisible;
      });
    }

    _previousScrollPosition = currentPosition;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final postService = ref.watch(postServiceProvider.notifier);
    final postFilter = ref.watch(postFilterProvider);

    return Scaffold(
      body: SafeArea(
        top: !_isAppBarVisible && !_holdSafeArea,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            HomePageAppBar(
                context: context,
                colorScheme: colorScheme,
                postService: postService),
            CupertinoSliverRefreshControl(
              onRefresh: () => postService.refreshFeed(postFilter),
            ),
            const PostList(),
          ],
        ),
      ),
    );
  }
}

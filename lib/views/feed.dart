import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/views/post_list.dart';
import 'package:snowpack/widgets/logo_button.dart';
import 'package:snowpack/widgets/settings_button.dart';
import 'package:snowpack/widgets/sort_button.dart';
import 'package:snowpack/widgets/elevation_dropdown.dart';
import 'package:snowpack/widgets/temperature_dropdown.dart';

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

    print("holdSafeArea: $_holdSafeArea");
    print("isAppBarVisible: $_isAppBarVisible");
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
    final postService = ref.read(postServiceProvider.notifier);

    void settingsPressed() {
      print("Settings Pressed");
      FilterMenu(context, postService);
    }

    return Scaffold(
      body: SafeArea(
        top: !_isAppBarVisible && !_holdSafeArea,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            HomePageAppBar(context, colorScheme, settingsPressed, postService),
            CupertinoSliverRefreshControl(
              onRefresh: () => postService.refreshFeed(),
            ),
            const PostList(),
          ],
        ),
      ),
    );
  }

  SliverAppBar HomePageAppBar(BuildContext context, ColorScheme colorScheme,
      void Function() settingsPressed, PostService postService) {
    return SliverAppBar(
      floating: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 4.0,
      leading: LogoButton(context: context, colorScheme: colorScheme),
      actions: [
        SettingsButton(settingsPressed: settingsPressed),
        SortButton(postService: postService),
      ],
    );
  }

  void FilterMenu(BuildContext context, PostService postService) {
    final initialElevationValue = postService.currentElevationFilter ?? 0;
    final initialAspectValue = postService.currentAspectFilter;
    final initialTemperatureValue = postService.currentTemperatureFilter ?? 0;

    const aspects = Aspect.values;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Posts'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevationDropdown(
                  postService: postService,
                  initialElevationValue: initialElevationValue),
              SizedBox(height: 20),
              AspectDropdown(postService, aspects, initialAspectValue),
              SizedBox(height: 20),
              TemperatureDropdown(
                  postService: postService,
                  initialTemperatureValue: initialTemperatureValue),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                postService.clearFilters();
                Navigator.of(context).pop();
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  DropdownButton<Aspect> AspectDropdown(PostService postService,
      List<Aspect> aspects, Aspect? initialAspectValue) {
    return DropdownButton<Aspect>(
      hint: Text('Select Aspect'),
      value: initialAspectValue,
      onChanged: (value) {
        if (value != null) {
          postService.setAspectFilter(value);
          print("Selected Aspect: ${value.toString().split('.').last}");
        }
      },
      items: aspects.map((Aspect aspect) {
        return DropdownMenuItem<Aspect>(
          value: aspect,
          child: Text(aspect.toString().split('.').last),
        );
      }).toList(),
    );
  }
}

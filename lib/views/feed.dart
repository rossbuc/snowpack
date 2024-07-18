import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/views/post_list.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final currentPosition = _scrollController.position.pixels;
    final isAtTop = currentPosition <= 0;
    final isAppBarVisible = currentPosition < 100;

    if (_isAppBarVisible != isAppBarVisible || isAtTop) {
      setState(() {
        _isAppBarVisible = isAppBarVisible;
      });
    }
    print(_isAppBarVisible);
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
      _showFilterMenu(context, postService);
    }

    return Scaffold(
      body: SafeArea(
        top:
            !_isAppBarVisible, // Conditionally render SafeArea based on AppBar visibility
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification ||
                scrollNotification is ScrollEndNotification) {
              _scrollListener();
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(
                  context, colorScheme, settingsPressed, postService),
              const PostList(),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, ColorScheme colorScheme,
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
      leading: _buildLogoButton(context, colorScheme),
      actions: [
        _buildSettingsButton(settingsPressed),
        _buildSortButton(postService),
      ],
    );
  }

  Padding _buildLogoButton(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashColor: colorScheme.secondary.withOpacity(0.5),
          onTap: _onLogoTap,
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

  Padding _buildSettingsButton(void Function() settingsPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: const Icon(CupertinoIcons.gear_alt),
        onPressed: settingsPressed,
      ),
    );
  }

  Padding _buildSortButton(PostService postService) {
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

  void _onLogoTap() {
    print("Logo Pressed");
  }

  void _showFilterMenu(BuildContext context, PostService postService) {
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
              _buildElevationDropdown(postService, initialElevationValue),
              SizedBox(height: 20),
              _buildAspectDropdown(postService, aspects, initialAspectValue),
              SizedBox(height: 20),
              _buildTemperatureDropdown(postService, initialTemperatureValue),
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

  DropdownButton<int> _buildElevationDropdown(
      PostService postService, int initialElevationValue) {
    return DropdownButton<int>(
      value: initialElevationValue,
      onChanged: (value) {
        if (value != null) {
          postService.setElevationFilter(value);
          print("Selected Elevation: $value ft");
        }
      },
      items: List.generate(
        110,
        (index) => DropdownMenuItem<int>(
          value: index * 100,
          child: Text('${index * 100} ft'),
        ),
      ),
    );
  }

  DropdownButton<Aspect> _buildAspectDropdown(PostService postService,
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

  DropdownButton<int> _buildTemperatureDropdown(
      PostService postService, int initialTemperatureValue) {
    return DropdownButton<int>(
      hint: Text("Select Temperature Range"),
      value: initialTemperatureValue,
      onChanged: (value) {
        if (value != null) {
          postService.setTemperatureFilter(value);
          print("Selected Temperature: $value degrees");
        }
      },
      items: List.generate(
        10,
        (index) => DropdownMenuItem<int>(
          value: (index - 5) * 5,
          child: Text('${(index - 5) * 5} degrees'),
        ),
      ),
    );
  }
}


// Above code copied from GPT but result is same as previous code... 
// need to understand what the goal is with the state managmenent here and how gpt is deciding to render the top of SafeArea 
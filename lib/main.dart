import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/post.dart';
import 'package:snowpack/views/avi_report.dart';
import 'package:snowpack/views/feed.dart';
import 'package:snowpack/views/post_create.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/models/user.dart';
import 'package:snowpack/services/user_service.dart';
import 'package:snowpack/views/search_screen.dart';
import 'package:snowpack/views/user_homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  print("dotenv loaded with IP_ADDRESS: ${dotenv.env['IP_ADDRESS']}");
  runApp(const ProviderScope(child: MyApp()));
}

final postServiceProvider =
    StateNotifierProvider<PostService, List<Post>>((ref) => PostService([]));

final userServiceProvider =
    StateNotifierProvider<UserService, List<User>>((ref) => UserService([]));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snowpack Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 123, 182, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> body = [
    const Center(
      child: Feed(),
    ),
    Center(
      child: SearchScreen(),
    ),
    Center(
      child: PostCreate(),
    ),
    const Center(
      child: AviReport(),
    ),
    const Center(
      child: UserHomepage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.snow),
            label: "Avi Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: "User",
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}

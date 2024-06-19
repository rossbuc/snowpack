import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/models/post.dart';
import 'package:snowpack/views/post_create.dart';
import 'package:snowpack/views/post_list.dart';
import 'package:snowpack/services/post_service.dart';
import 'package:snowpack/models/user.dart';
import 'package:snowpack/services/user_service.dart';

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
      child: PostList(),
    ),
    const Center(
      child: Text("Search"),
    ),
    Center(
      child: PostCreate(),
    ),
    const Center(
      child: Text("Avi Report"),
    ),
    const Center(
      child: Text("User"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 4.0, bottom: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              splashColor: colorScheme.secondary.withOpacity(0.5),
              onTap: _onLogoTap,
              child: SizedBox(
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.gear_alt),
              onPressed: () {
                settingsPressed();
              },
            ),
          )
        ],
      ),
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

  void settingsPressed() {
    print("Settings Pressed");
  }

  void _onLogoTap() {
    print("Logo Pressed");
  }
}

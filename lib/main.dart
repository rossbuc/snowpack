import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snowpack/post.dart';
import 'package:snowpack/post_list.dart';
import 'package:snowpack/post_service.dart';
import 'package:snowpack/user.dart';
import 'package:snowpack/user_service.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final postServiceProvider =
    StateNotifierProvider<PostService, List<Post>>((ref) => PostService([]));

final userServiceProvider =
    StateNotifierProvider<UserService, List<User>>((ref) => UserService([]));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  final List<Widget> body = const [
    Center(
      child: PostList(),
    ),
    Center(
      child: Text("Search"),
    ),
    Center(
      child: Text("Post"),
    ),
    Center(
      child: Text("Avi Report"),
    ),
    Center(
      child: Text("User"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
    );
  }
}

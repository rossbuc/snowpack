import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ProviderScope(child: MyApp()));

final postSereviceProvider =
    StateNotifierProvider<PostService, List<Post>>((ref) => PostService([]));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  List<Widget> body = const [
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

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts();
  }

// Make sure that when you migrate to using a db on Railway you change to https
  Future<List<dynamic>> getPosts() async {
    final url = Uri.http("localhost:8080", "/posts");

    print("get post called with thiss url: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load posts with error code : $e');
    }
  }
}

class Post {
  final int xcoordinate;
  final int ycoordinate;
  final String description;
  final int elevation;
  final String aspect;
  final int temperature;
  final User user;

  Post({
    required this.xcoordinate,
    required this.ycoordinate,
    required this.description,
    required this.elevation,
    required this.aspect,
    required this.temperature,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      xcoordinate: json['xcoordinate'],
      ycoordinate: json['ycoordinate'],
      description: json['description'],
      elevation: json['elevation'],
      aspect: json['aspect'],
      temperature: json['temperature'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final String username;
  final String password;
  final String email;
  final List<Post> posts;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var postList = json['posts'] as List;
    List<Post> posts = postList.map((i) => Post.fromJson(i)).toList();
    return User(
      username: json['username'],
      password: json['password'],
      email: json['email'],
      posts: posts,
    );
  }
}

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postSereviceProvider);
    print("this is the list of posts: $posts");
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Text(posts[index].description);
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ProviderScope(child: MyApp()));

final postServiceProvider =
    StateNotifierProvider<PostService, List<Post>>((ref) => PostService([]));

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

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts().then((value) => state = value);
  }

  Future<List<Post>> getPosts() async {
    final url = Uri.http("localhost:8080", "/posts");

    print("get post called with this url: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        print("Data received: $data");
        List<Post> posts = data.map((json) {
          try {
            return Post.fromJson(json);
          } catch (e) {
            print("Error parsing post: $e, data: $json");
            throw e;
          }
        }).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception('Failed to load posts with error code: $e');
    }
  }
}

class Post {
  final int id;
  final int xcoordinate;
  final int ycoordinate;
  final String description;
  final int elevation;
  final String aspect;
  final int temperature;
  final User user;

  Post({
    required this.id,
    required this.xcoordinate,
    required this.ycoordinate,
    required this.description,
    required this.elevation,
    required this.aspect,
    required this.temperature,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    print("Parsing Post from JSON: $json");
    return Post(
      id: json['id'] ??
          (throw Exception(
              "Post ID is required, post id provided: ${json['id']}")),
      xcoordinate: json['xcoordinate'] ?? 0,
      ycoordinate: json['ycoordinate'] ?? 0,
      description: json['description'] ?? "No description",
      elevation: json['elevation'] ?? 0,
      aspect: json['aspect'] ?? "No aspect",
      temperature: json['temperature'] ?? 0,
      user:
          User.fromJson(json['user'] ?? (throw Exception("User is required"))),
    );
  }
}

class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final List<Post> posts;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.posts,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing User from JSON: $json");
    var postList = json['posts'] as List? ?? [];
    List<Post> posts = postList.map((i) {
      try {
        return Post.fromJson(i);
      } catch (e) {
        print("Error parsing post in user: $e, data: $i");
        throw e;
      }
    }).toList();
    return User(
      id: json['id'] ??
          (throw Exception(
              "User ID is required, value provided is: ${json['id']}")),
      username: json['username'] ?? "",
      password: json['password'] ?? "",
      email: json['email'] ?? "",
      posts: posts,
    );
  }
}

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postServiceProvider);
    print("This is the list of posts: $posts");
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(posts[index].description),
          subtitle: Text(
              'Coordinates: (${posts[index].xcoordinate}, ${posts[index].ycoordinate})'),
        );
      },
    );
  }
}

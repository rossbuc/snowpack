import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts().then((posts) => state = posts);
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

class UserService extends StateNotifier<List<User>> {
  UserService(super.state) {
    getUsers().then((users) => state = users);
  }

  Future<List<User>> getUsers() async {
    final url = Uri.http("localhost:8080", "/users");
    print("get users called with this url: $url");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        print("Data received: $data");
        List<User> users = data.map((json) {
          try {
            return User.fromJson(json);
          } catch (e) {
            print("Error parsing user: $e, data: $json");
            throw e;
          }
        }).toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception('Failed to load users with error code: $e');
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
  final int userId;

  Post({
    required this.id,
    required this.xcoordinate,
    required this.ycoordinate,
    required this.description,
    required this.elevation,
    required this.aspect,
    required this.temperature,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
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
      userId: json['user']['id'],
    );
  }
}

class User {
  final int id;
  final String username;
  final String password;
  final String email;
  final List<int> postIds;
  final List<int> followerIds;
  final List<int> followingIds;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.postIds,
    required this.followerIds,
    required this.followingIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing User from JSON: $json");

    // // Convert the list of posts to a list of Post objects
    // var postList = json['posts'] as List? ?? [];
    // List<Post> posts = postList.map((i) {
    //   try {
    //     return Post.fromJson(i, []);
    //   } catch (e) {
    //     print("Error parsing post in user: $e, data: $i");
    //     throw e;
    //   }
    // }).toList();

    // Convert the list of posts into a list of postids
    var postList = json['posts'] as List? ?? [];
    List<int> postIds = postList
        .map((post) {
          try {
            return post['id'];
          } catch (e) {
            print("Error parsing post in user: $e, data: $post");
            throw e;
          }
        })
        .cast<int>()
        .toList();

    // // Convert the list of followers to a list of User objects
    // var followersList = json['followers'] as List? ?? [];
    // List<User> followers = followersList.map((i) {
    //   try {
    //     return User.fromJson(i);
    //   } catch (e) {
    //     print("Error parsing followers in user: $e, data: $i");
    //     throw e;
    //   }
    // }).toList();

    var followersList = json['followers'] as List? ?? [];
    List<int> followers = followersList
        .map((follower) {
          try {
            return follower['id'];
          } catch (e) {
            print("Error parsing followers in user: $e, data: $follower");
            throw e;
          }
        })
        .cast<int>()
        .toList();

    // // Convert the list of following to a list of User objects
    // var followingList = json['following'] as List? ?? [];
    // List<User> following = followingList.map((i) {
    //   try {
    //     return User.fromJson(i);
    //   } catch (e) {
    //     print("Error parsing the followng in user: $e, data: $i");
    //     throw e;
    //   }
    // }).toList();

    var followingList = json['following'] as List? ?? [];
    List<int> following = followingList
        .map((following) {
          try {
            return following['id'];
          } catch (e) {
            print("Error parsing the following in user: $e, data: $following");
            throw e;
          }
        })
        .cast<int>()
        .toList();
    return User(
      id: json['id'] ??
          (throw Exception(
              "User ID is required, value provided is: ${json['id']}")),
      username: json['username'] ?? "",
      password: json['password'] ?? "",
      email: json['email'] ?? "",
      postIds: postIds,
      followerIds: followers,
      followingIds: following,
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

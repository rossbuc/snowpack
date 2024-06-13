import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  print("helo world");
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: IconButton(
            onPressed: getPosts,
            icon: Icon(CupertinoIcons.list_bullet_below_rectangle)),
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
        onTap: navBarTapped,
      ),
    );
  }

  void navBarTapped(int value) {
    print("nav bar pressed and this was the value, $value");
  }
}

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

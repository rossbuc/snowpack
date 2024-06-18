import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snowpack/models/post.dart';

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts().then((posts) => state = posts);
  }

  Future<List<Post>> getPosts() async {
    final url = Uri.http(dotenv.env['IP_ADDRESS']!, "/posts");

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
            if (json['dateTime'] == null) {
              print("dateTime is null for post: $json");
            } else {
              print("Invalid datetime format for post: ${json['dateTime']}");
            }
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

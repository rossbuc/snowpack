import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post.dart';
import 'package:snowpack/models/post_filter.dart';

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts().then((posts) => state = posts);
  }

  Future<List<Post>> getPosts(
      {String? sortBy,
      int? elevation,
      Aspect? aspect,
      int? temperature}) async {
    final queryParams = <String, String>{};
    if (sortBy != null) {
      queryParams['sortBy'] = sortBy;
    }
    if (elevation != null) {
      queryParams['elevation'] = elevation.toString();
    }
    if (aspect != null) {
      queryParams['aspect'] = aspect.name;
    }
    if (temperature != null) {
      queryParams['temperature'] = temperature.toString();
    }
    final url = Uri.http(dotenv.env['IP_ADDRESS']!, "/posts", queryParams);

    print("get post called with this url: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        // print("Data received: $data");
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

  Future<List<Post>> getPostsWithCurrentFilters(PostFilter postFilter) async =>
      getPosts(
        elevation: postFilter.elevationFilter,
        aspect: postFilter.aspectFilter,
        temperature: postFilter.temperatureFilter,
      ).then((posts) => state = posts);

  Future<void> refreshFeed(PostFilter postFilter) async {
    getPostsWithCurrentFilters(postFilter).then((posts) => state = posts);
  }

  Future<void> createPost(Post post) async {
    final url = Uri.http(dotenv.env['IP_ADDRESS']!, "/posts/new");

    String aspect = post.aspect.toString().split('.').last;
    print("this is the aspect: $aspect");

    final Map<String, dynamic> requestBody = {
      'xcoordinate': post.xcoordinate,
      'ycoordinate': post.ycoordinate,
      'dateTime': post.dateTime.toIso8601String(),
      'title': post.title,
      'description': post.description,
      'elevation': post.elevation,
      'aspect': aspect,
      'temperature': post.temperature,
      'user': {'id': post.userId},
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    print("this is the post we're trying to create: ${post.dateTime}");
    if (response.statusCode == 200) {
      print('Post created successfully');
    } else {
      print('Failed to create post: ${response.statusCode}');
      throw Exception('Failed to create post: ${response.statusCode}');
    }
  }

  void sortPosts(String criteria) {
    if (criteria == 'time') {
      print("Sorting by Time");
      // Add your sorting logic here
      getPosts(sortBy: "recent").then((posts) => state = posts);
    } else if (criteria == 'location') {
      print("Sorting by Location");
      // Add your sorting logic here
    }
  }

  Future<void> updatePost(Post updatedPost) async {
    final url =
        Uri.http(dotenv.env['IP_ADDRESS']!, "/posts/${updatedPost.id}/edit");

    String aspect = updatedPost.aspect.toString().split('.').last;

    print("trying to update this post: updatedPost: $updatedPost");
    print("using this url to update: $url");

    final Map<String, dynamic> requestBody = {
      'xcoordinate': updatedPost.xcoordinate,
      'ycoordinate': updatedPost.ycoordinate,
      'dateTime': updatedPost.dateTime.toIso8601String(),
      'title': updatedPost.title,
      'description': updatedPost.description,
      'elevation': updatedPost.elevation,
      'aspect': aspect,
      'temperature': updatedPost.temperature,
      'user': {'id': updatedPost.userId},
    };

    final response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(requestBody));
    if (response.statusCode == 200) {
      print('Post updated successfully');
    } else {
      print('Failed to update post: ${response.statusCode}');
      throw Exception('Failed to update post: ${response.statusCode}');
    }
  }
}

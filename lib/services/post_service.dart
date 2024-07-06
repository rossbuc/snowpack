import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post.dart';

class PostService extends StateNotifier<List<Post>> {
  PostService(super.state) {
    getPosts().then((posts) => state = posts);
  }

  int? _currentElevationFilter;

  int? get currentElevationFilter => _currentElevationFilter;

  Future<List<Post>> getPosts(
      {String? sortBy, int? elevation, Aspect? aspect}) async {
    final queryParams = <String, String>{};
    if (sortBy != null) {
      queryParams['sortBy'] = sortBy;
    }
    if (elevation != null) {
      queryParams['elevation'] = elevation.toString();
    }
    if (aspect != null) {
      queryParams['aspect'] = aspect.toString();
    }
    final url = Uri.http(dotenv.env['IP_ADDRESS']!, "/posts", queryParams);

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

  void setElevationFilter(int elevation) {
    _currentElevationFilter = elevation;
    // Optionally, you might want to fetch posts with the new elevation filter here
    getPosts(elevation: elevation).then((posts) => state = posts);
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
    } else if (criteria == 'location') {
      print("Sorting by Location");
      // Add your sorting logic here
    }
  }
}

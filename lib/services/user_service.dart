import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snowpack/models/user.dart';
import 'package:collection/collection.dart';

class UserService extends StateNotifier<List<User>> {
  UserService(super.state) {
    getUsers().then((users) => state = users);
  }

  Future<List<User>> getUsers() async {
    final url = Uri.http(dotenv.env['IP_ADDRESS']!, "/users");
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

  User? getUserById(int id) {
    return state.firstWhereOrNull((user) => user.id == id);
  }
}

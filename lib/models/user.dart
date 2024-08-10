class User {
  final int? id;
  final String username;
  final String password;
  final String email;
  final List<int> postIds;
  final List<int> followerIds;
  final List<int> followingIds;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.postIds,
    required this.followerIds,
    required this.followingIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing User from JSON: $json");

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

    // Convert the list of followers into a list of User Id's
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

    // Convert the list of following into a list of User Id's
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

  User copyWith({
    String? username,
    String? password,
    String? email,
    List<int>? postIds,
    List<int>? followerIds,
    List<int>? followingIds,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      postIds: postIds ?? this.postIds,
      followerIds: followerIds ?? this.followerIds,
      followingIds: followingIds ?? this.followingIds,
    );
  }
}

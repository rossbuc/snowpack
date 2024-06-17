class Post {
  final int id;
  final int xcoordinate;
  final int ycoordinate;
  final DateTime dateTime;
  final String title;
  final String description;
  final int elevation;
  final String aspect;
  final int temperature;
  final int userId;

  Post({
    required this.id,
    required this.xcoordinate,
    required this.ycoordinate,
    required this.dateTime,
    required this.title,
    required this.description,
    required this.elevation,
    required this.aspect,
    required this.temperature,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception("Post ID is required, post id provided: ${json['id']}");
    }
    if (json['user'] == null || json['user']['id'] == null) {
      throw Exception("User ID is required, user id provided: ${json['user']}");
    }

    DateTime dateTime;
    try {
      dateTime = DateTime.parse(json['dateTime']);
    } catch (e) {
      print("Invalid date format for dateTime: ${json['dateTtime']}");
      throw const FormatException("Invalid date format");
    }

    return Post(
      id: json['id'],
      xcoordinate: json['xcoordinate'] ?? 0,
      ycoordinate: json['ycoordinate'] ?? 0,
      dateTime: dateTime,
      title: json['title'] ?? "No title",
      description: json['description'] ?? "No description",
      elevation: json['elevation'] ?? 0,
      aspect: json['aspect'] ?? "No aspect",
      temperature: json['temperature'] ?? 0,
      userId: json['user']['id'],
    );
  }
}

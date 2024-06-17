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

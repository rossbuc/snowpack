import 'package:flutter/material.dart';
import 'package:snowpack/models/post.dart';

class PostDisplay extends StatelessWidget {
  final Post post;

  const PostDisplay({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'navigateToFeed');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(post.description),
            SizedBox(height: 16),
            Text('Elevation: ${post.elevation} m'),
            SizedBox(height: 16),
            Text('Aspect: ${post.aspect.toString().split('.').last}'),
            SizedBox(height: 16),
            Text('Temperature: ${post.temperature}°C'),
          ],
        ),
      ),
    );
  }
}

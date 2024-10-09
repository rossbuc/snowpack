import 'package:flutter/material.dart';
import 'package:snowpack/models/post.dart';

class PostDisplay extends StatelessWidget {
  final Post post;

  const PostDisplay({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.description),
            const SizedBox(height: 16),
            Text('Elevation: ${post.elevation} m'),
            const SizedBox(height: 16),
            Text('Aspect: ${post.aspect.toString().split('.').last}'),
            const SizedBox(height: 16),
            Text('Temperature: ${post.temperature}°C'),
          ],
        ),
      ),
    );
  }
}

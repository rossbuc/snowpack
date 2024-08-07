import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post.dart';
import 'package:snowpack/providers/post_form_provider.dart';
import 'package:snowpack/views/feed.dart';
import 'package:snowpack/views/post_display.dart';

class PostCreate extends ConsumerWidget {
  PostCreate({super.key});

  final _formKey = GlobalKey<FormState>();
  final postFormProvider = ChangeNotifierProvider((ref) => PostFormProvider());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postForm = ref.watch(postFormProvider);
    final postFormNotifier = ref.read(postFormProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final postService = ref.read(postServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Title",
                    prefixIcon: Icon(CupertinoIcons.textformat),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    postFormNotifier.setTitle(value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(CupertinoIcons.text_alignleft),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    postFormNotifier.setDescription(value);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Elevation",
                    prefixIcon: Icon(CupertinoIcons.up_arrow),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the elevation';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    postFormNotifier.setElevation(value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Aspect>(
                  value: postForm.aspect,
                  decoration: const InputDecoration(
                    labelText: 'Aspect',
                    prefixIcon: Icon(CupertinoIcons.compass),
                  ),
                  items: Aspect.values.map((Aspect aspect) {
                    return DropdownMenuItem<Aspect>(
                      value: aspect,
                      child: Text(aspect.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Aspect? value) {
                    postFormNotifier.setAspect(value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an aspect';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  // need to center this scrollview on the 0°C item if possible
                  decoration: const InputDecoration(
                    labelText: "Temperature",
                    prefixIcon: Icon(CupertinoIcons.thermometer_snowflake),
                  ),
                  items: List.generate(
                    100,
                    (index) => DropdownMenuItem(
                      value: index - 50,
                      child: Text("${index - 50}°C"),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter the temperature';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    postFormNotifier.setTemperature(value);
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Post",
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      Post post = Post(
                        xcoordinate: 0,
                        ycoordinate: 0,
                        dateTime: DateTime.now(),
                        title: postForm.title!,
                        description: postForm.description!,
                        elevation: int.parse(postForm.elevation!),
                        aspect: postForm.aspect!,
                        temperature: postForm.temperature!,
                        userId: 1,
                      );
                      postService.createPost(post);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Post created: ${post.title}")),
                      );
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDisplay(post: post),
                        ),
                      );

                      if (result == 'navigateToFeed') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Feed(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

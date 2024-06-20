import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/aspect.dart';
import 'package:snowpack/models/post.dart';
import 'package:snowpack/providers/post_form_provider.dart';

class PostCreate extends ConsumerWidget {
  // late String? _xCoordinate;
  // late String? _yCoordinate;
  // late String? _dateTime;
  // late String _title;
  // late String _description;
  // late String _elevation;
  // late Aspect _aspect;
  // late String _temperature;
  // late String _userId;

  PostCreate({super.key});

  final _formKey = GlobalKey<FormState>();
  final postFormProvider = ChangeNotifierProvider((ref) => PostFormProvider());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postForm = ref.watch(postFormProvider);
    final postFormNotifiter = ref.read(postFormProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final postService = ref.read(postServiceProvider.notifier);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  postFormNotifiter.setTitle(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  postFormNotifiter.setDescription(value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Elevation"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  postFormNotifiter.setElevation(value);
                },
              ),
              DropdownButtonFormField<Aspect>(
                value: postForm.aspect,
                decoration: const InputDecoration(labelText: 'Aspect'),
                items: Aspect.values.map((Aspect aspect) {
                  return DropdownMenuItem<Aspect>(
                    value: aspect,
                    child: Text(aspect.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (Aspect? value) {
                  postFormNotifiter.setAspect(value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an aspect';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Temperature"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  postFormNotifiter.setTemperature(value);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                child: Text(
                  "Post",
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  // _formKey.currentState!.save();

                  Post post = Post(
                    // id: 1,
                    xcoordinate:
                        0, // Again hard coded in coordinates and will move to use either current location or more likely a pin drop on a map api
                    ycoordinate: 0,
                    dateTime: DateTime
                        .now(), // Keep as dateTime when post is created for now then change later to allow user to set time of each run, as its unlikely they're gonna post after every run or even that day
                    title: postForm.title!,
                    description: postForm.description!,
                    elevation: int.parse(postForm.elevation!),
                    aspect: postForm.aspect!,
                    temperature: int.parse(postForm.temperature!),
                    userId:
                        1, //Hard coding in rossbuc (userId 1) for now then will pull from logged in user once functionality is there
                  );
                  postService.createPost(post);
                  print("post created: $post");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

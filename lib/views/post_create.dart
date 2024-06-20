import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/post.dart';

class PostCreate extends ConsumerWidget {
  // late String? _xCoordinate;
  // late String? _yCoordinate;
  // late String? _dateTime;
  late String _title;
  late String _description;
  late String _elevation;
  late String _aspect;
  late String _temperature;
  late String _userId;

  PostCreate({super.key});

  final _formKey = GlobalKey<FormState>();

  Widget _buildTitleField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Title"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _title = value!;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Description"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _description = value!;
      },
    );
  }

  Widget _buildElevationField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Elevation"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _elevation = value!;
      },
    );
  }

  Widget _buildAspectField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Aspect"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _aspect = value!;
      },
    );
  }

  Widget _buildTemperatureField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Temperature"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _temperature = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildTitleField(),
              _buildDescriptionField(),
              _buildElevationField(),
              _buildAspectField(),
              _buildTemperatureField(),
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

                  _formKey.currentState!.save();

                  Post post = Post(
                    // id: 1,
                    xcoordinate:
                        0, // Again hard coded in coordinates and will move to use either current location or more likely a pin drop on a map api
                    ycoordinate: 0,
                    dateTime: DateTime
                        .now(), // Keep as dateTime when post is created for now then change later to allow user to set time of each run, as its unlikely they're gonna post after every run or even that day
                    title: _title,
                    description: _description,
                    elevation: int.parse(_elevation),
                    aspect: _aspect,
                    temperature: int.parse(_temperature),
                    userId:
                        1, //Hard coding in rossbuc (userId 1) for now then will pull from logged in user once functionality is there
                  );
                  postService.createPost(post);
                  print(
                      "form saved: $_title, $_description, $_elevation, $_aspect, $_temperature, $_userId");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

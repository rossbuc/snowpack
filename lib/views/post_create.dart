import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snowpack/main.dart';
import 'package:snowpack/models/post.dart';

class PostCreate extends ConsumerWidget {
  // late String? _xCoordinate;
  // late String? _yCoordinate;
  // late String? _dateTime;
  late String? _title;
  late String? _description;
  late String? _elevation;
  late String? _aspect;
  late String? _temperature;
  late String? _userId;

  PostCreate({super.key});

  final _formKey = GlobalKey<FormState>();

  // Widget _buildxCoordinateField() {
  //   return TextFormField(
  //     decoration: const InputDecoration(
  //       labelText: "X Coordinate",
  //     ),
  //     validator: (String? value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter some text';
  //       }
  //       return null;
  //     },
  //     onSaved: (String? value) {
  //       _xCoordinate = value;
  //     },
  //   );
  // }

  // Widget _buildyCoordinateField() {
  //   return TextFormField(
  //     decoration: const InputDecoration(
  //       labelText: "Y Coordinate",
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter some text';
  //       }
  //       return null;
  //     },
  //     onSaved: (String? value) {
  //       _yCoordinate = value;
  //     },
  //   );
  // }

  // Widget _buildDateTimeField() {
  //   return TextFormField(
  //     decoration: const InputDecoration(
  //       labelText: "Enter Date and Time (YYYY-MM-DD HH:MM:SS)",
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return 'Please enter some text';
  //       }
  //       return null;
  //     },
  //     onSaved: (String? value) {
  //       _dateTime = value;
  //     },
  //   );
  // }

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
        _title = value;
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
        _description = value;
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
        _elevation = value;
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
        _aspect = value;
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
        _temperature = value;
      },
    );
  }

  Widget _buildUserIdField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "User ID"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        _userId = value;
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final postService = ref.read(postServiceProvider.notifier);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16),
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
              _buildUserIdField(),
              SizedBox(height: 20),
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
                    id: 0,
                    xcoordinate: 0,
                    ycoordinate: 0,
                    dateTime: DateTime.now(),
                    title: "trial post from the ting",
                    description: "this is a trial post boss",
                    elevation: 100000,
                    aspect: "N",
                    temperature: 2,
                    userId: 1,
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
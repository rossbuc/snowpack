import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCreate extends StatelessWidget {
  Widget _buildxCoordinateField() {
    return null;
  }

  Widget _buildyCoordinateField() {
    return null;
  }

  Widget _buildDateTimeField() {
    return null;
  }

  Widget _buildTitleField() {
    return null;
  }

  Widget _buildDescriptionField() {
    return null;
  }

  Widget _buildElevationField() {
    return null;
  }

  Widget _buildAspectField() {
    return null;
  }

  Widget _buildTemperatureField() {
    return null;
  }

  Widget _buildUserIdField() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildxCoordinateField(),
              _buildyCoordinateField(),
              _buildDateTimeField(),
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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

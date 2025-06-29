import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicker extends StatelessWidget {
  const ProfilePicker({
    super.key,
    required this.selectedImage,
    
  });

  final XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey,
      foregroundImage:
          selectedImage != null ? FileImage(File(selectedImage!.path)) : null,
      child: selectedImage == null
          ? Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).primaryColor,
            )
          : null,
    );
  }
}
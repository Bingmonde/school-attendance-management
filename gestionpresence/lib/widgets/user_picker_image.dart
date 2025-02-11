import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);
  final Function(XFile pickImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _photoFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
        maxHeight: 150);

    setState(() {
      _pickedImage = XFile(_photoFile!.path);
      widget.imagePickFn(_pickedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: (_pickedImage != null)
              ? FileImage(File(_pickedImage!.path))
              : null,
        ),
        if (_pickedImage != null) Image.file(File(_pickedImage!.path)),
        TextButton.icon(
          onPressed: (() {
            _pickImage();
          }),
          icon: Icon(Icons.image),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}

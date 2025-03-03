import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.onImagePicked});

  final Function(String) onImagePicked;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _image = savedImage;
      });

      widget.onImagePicked(savedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: const Text('Seleccionar Imagen'),
        ),
        const SizedBox(height: 20),
        if (_image != null)
          Image.file(
            _image!,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
      ],
    );
  }
}

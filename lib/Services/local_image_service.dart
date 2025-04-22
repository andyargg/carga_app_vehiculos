import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalImageService {
  Future<String> saveImage(File image, {String? customPath}) async {
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = path.join(directory.path, customPath ?? 'images', path.basename(image.path));
    await Directory(path.dirname(filePath)).create(recursive: true);
    final File savedImage = await image.copy(filePath);
    return savedImage.path;
  }

  Future<File?> getImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);

      if (await imageFile.exists()) {
        return imageFile;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalImageService {
  // guarda la imagen localmente y devuelve la ruta de la imagen
  static Future<String?> saveImage(File image, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/images';
      final folder = Directory(path);

      // crear la carpeta si no existe
      if (!folder.existsSync()) {
        await folder.create(recursive: true);
      }

      final newImagePath = '$path/$fileName';
      final newImage = await image.copy(newImagePath);
      
      return newImage.path;
    } catch (e) {
      print('Error al guardar la imagen: $e');
      return null;
    }
  }

  // Obtiene la imagen como archivo desde su ruta
  static File getImage(String imagePath) {
    return File(imagePath);
  }

  // Elimina la imagen local
  static Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}

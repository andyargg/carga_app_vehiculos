import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class SupabaseVehicleRepository {
  final SupabaseClient _supabase;

  // nombre del bucket
  final String _imageBucket = 'camioneta_archivos';

  SupabaseVehicleRepository(this._supabase);

  // singleton
  SupabaseVehicleRepository.instance() : _supabase = Supabase.instance.client;

  // guardar una imagen y devolver su URL pública
  Future<String?> save(String? localImagePath) async {
    try {
      if (localImagePath != null) {
        final imageFile = File(localImagePath);

        // nombre unico
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

        // subir la imagen al bucket
        await _supabase.storage
            .from(_imageBucket)
            .upload(fileName, imageFile);

        //url publica
        final String imageUrl = _supabase.storage
            .from(_imageBucket)
            .getPublicUrl(fileName);

        return imageUrl;
      }
      return null;
    } catch (e) {
      throw Exception('Error al guardar la imagen: $e');
    }
  }
}
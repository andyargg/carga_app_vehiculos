import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class SupabaseVehicleRepository {
  final SupabaseClient _supabase;
  
  //bucket
  final String _imageBucket = 'camioneta_archivos';
  
  SupabaseVehicleRepository(this._supabase);
  
  //singleton
  SupabaseVehicleRepository.instance() : _supabase = Supabase.instance.client;
  
  //guardar una imagen
  Future<String?> save(String? localImagePath) async {
    try {
      if (localImagePath != null) {

        final imageFile = File(localImagePath);

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

        
        final imageStorageUrl = await _supabase.storage
            .from(_imageBucket)
            .upload(fileName, imageFile);
        
        return imageStorageUrl;
      }
      return null;
    } catch (e) {
      throw Exception('Error al guardar vehículo: $e');
    }
  }
}
  

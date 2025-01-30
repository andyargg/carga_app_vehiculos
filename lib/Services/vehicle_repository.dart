import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/vehicle.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore;

  VehicleRepository(this._firestore);

  Future<String> save(Vehicle vehicle) async {
    final data = vehicle.toMap();
    
    if (vehicle.id == null) {
      final docRef = await _firestore.collection('vehicles').add(data);
      return docRef.id;
    } else {
      await _firestore.collection('vehicles').doc(vehicle.id).set(data);
      return vehicle.id!;
    }
  }

  Future<void> delete(String id) async {
    await _firestore.collection('vehicles').doc(id).delete();
  }
}
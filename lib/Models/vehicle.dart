import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? patent; // patente
  String? technician; //  nombre del tecnico
  String? order; // orden
  String? cleanliness; //limpieza
  String? water;  //agua
  String? spareTire; //rueda de auxilio
  String? oil;  //aceite
  String? jack;  // crique
  String? crossWrench; //llave cruz
  String? fireExtinguisher; //extinguidor
  String? lock; //candado
  final FirebaseFirestore  _firestore = FirebaseFirestore.instance;

  Vehicle({
    this.patent,
    this.technician,
    this.order,
    this.cleanliness,
    this.water,
    this.spareTire,
    this.oil,
    this.jack,
    this.crossWrench,
    this.fireExtinguisher,
    this.lock,
  });
  //metodo para pasarlo de Firestore a Vehicle
  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return Vehicle (
      patent: data['patent'],
      technician: data['technician'],
      order: data['order'],
      cleanliness: data['cleanliness'],
      water: data['water'],
      spareTire: data['spareTire'],
      oil: data['oil'],
      jack: data['jack'],
      crossWrench: data['crossWrench'],
      fireExtinguisher: data['fireExtinguisher'],
      lock: data['lock'],
    );
  }


  //metodo para mapearlo de Vehicle a Firestore
  Map<String, dynamic> toMap() {
    return {
      'patent': patent,
      'technician': technician,
      'order': order,
      'cleanliness': cleanliness,
      'water': water,
      'spareTire': spareTire,
      'oil': oil,
      'jack': jack,
      'crossWrench': crossWrench,
      'fireExtinguisher': fireExtinguisher,
      'lock': lock,
    };
  }





  //metodo para subir camioneta a la base de datos
  Future<void> save(String? id) async {
    
    
    if (id == null){
      //create
      await _firestore.collection('vehicles').add({
        'patent': patent,
        'technician': technician,
        'order': order,
        'cleanliness': cleanliness,
        'water': water,
        'spareTire': spareTire,
        'oil': oil,
        'jack': jack,
        'crossWrench': crossWrench,
        'fireExtinguisher': fireExtinguisher,
        'lock': lock,
      });
    } 
    //update
    else {
      await _firestore.collection('vehicles').doc(id).update({
        'patent': patent,
        'technician': technician,
        'order': order,
        'cleanliness': cleanliness,
        'water': water,
        'spareTire': spareTire,
        'oil': oil,
        'jack': jack,
        'crossWrench': crossWrench,
        'fireExtinguisher': fireExtinguisher,
        'lock': lock,
      });
    }
  }
  //delete
  Future<void> delete(String? id) async {
    if (id == null) {
      await FirebaseFirestore.instance.collection('vehicles').doc(id).delete();
    } else{
      Exception("No hay id");
    }
  }
}
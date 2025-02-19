  import 'package:cloud_firestore/cloud_firestore.dart';

  class Vehicle {
    final String? id;
    final Timestamp date;
    final String patent;
    final String technician;
    final String order;
    final String cleanliness;
    final String water;
    final String spareTire;
    final String oil;
    final String jack;
    final String crossWrench;
    final String fireExtinguisher;
    final String lock;
    final String comment;

    const Vehicle({
      this.id,
      required this.date,
      required this.patent,
      required this.technician,
      required this.order,
      required this.cleanliness,
      required this.water,
      required this.spareTire,
      required this.oil,
      required this.jack,
      required this.crossWrench,
      required this.fireExtinguisher,
      required this.lock,
      required this.comment,
    });

    factory Vehicle.fromFirestore(DocumentSnapshot doc) {
      if (!doc.exists) throw Exception("Document not found");
      final data = doc.data()! as Map<String, dynamic>;

      return Vehicle(
        id: doc.id,
        date: data['date'] as Timestamp,
        patent: data['patent'] as String,
        technician: data['technician'] as String,
        order: data['order'] as String,
        cleanliness: data['cleanliness'] as String,
        water: data['water'] as String,
        spareTire: data['spareTire'] as String,
        oil: data['oil'] as String,
        jack: data['jack'] as String,
        crossWrench: data['crossWrench'] as String,
        fireExtinguisher: data['fireExtinguisher'] as String,
        lock: data['lock'] as String,
        comment: data['comment'] as String,
      );
    }

    Map<String, dynamic> toMap() {
      return {
        'date': date,
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
        'comment': comment,
      };
    }
  }


    
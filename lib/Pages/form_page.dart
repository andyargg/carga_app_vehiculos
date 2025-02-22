import 'package:app_camionetas_empleado/Models/vehicle.dart';
import 'package:app_camionetas_empleado/Services/vehicle_repository.dart';
import 'package:app_camionetas_empleado/Widgets/dropdown_widget.dart';
import 'package:app_camionetas_empleado/Widgets/nav_bar_widget.dart';
import 'package:app_camionetas_empleado/Widgets/search_anchor_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<Vehicle> _pendingVehicles = [];
  int _editingVehicleIndex = -1;
  final _formKey = GlobalKey<FormState>();
  final VehicleRepository _repository = VehicleRepository(FirebaseFirestore.instance);
  final _patenteController = TextEditingController();
  final _tecnicoController = TextEditingController();
  final _commentController = TextEditingController();
  
  Map<String, String> _formValues = {
    'patent': '',
    'technician': '',
    'order': '',
    'cleanliness': '',
    'water': '',
    'spareTire': '',
    'oil': '',
    'jack': '',
    'crossWrench': '',
    'fireExtinguisher': '',
    'lock': '',
    'comment': '',
  };

  bool _isLoading = true;
  List<String> _patentes = [];
  List<String> _tecnicos = [];

  final Map<String, List<String>> _formOptions = {
    'cleanliness': ["Impecable", "Bien", "Algo descuidado", "Deficiente"],
    'yesNo': ["Sí", "No"],
  };

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _patenteController.dispose();
    _tecnicoController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final response = await rootBundle.loadString('assets/data.json');
      final data = json.decode(response) as Map<String, dynamic>;
      _patentes = List<String>.from(data['patentes']);
      _tecnicos = List<String>.from(data['tecnicos']);
    } catch (e) {
      _showError('Error loading initial data');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _addForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final vehicle = Vehicle(
        date: Timestamp.now(),
        patent: _formValues['patent']!,
        technician: _formValues['technician']!,
        order: _formValues['order']!,
        cleanliness: _formValues['cleanliness']!,
        water: _formValues['water']!,
        spareTire: _formValues['spareTire']!,
        oil: _formValues['oil']!,
        jack: _formValues['jack']!,
        crossWrench: _formValues['crossWrench']!,
        fireExtinguisher: _formValues['fireExtinguisher']!,
        lock: _formValues['lock']!,
        comment: _formValues['comment']!,
      );


      if (_editingVehicleIndex >= 0) {
        _pendingVehicles[_editingVehicleIndex] = vehicle;
        _editingVehicleIndex = -1;
      } else {
        _pendingVehicles.add(vehicle);
      }
      _showSuccess('Vehículo agregado exitosamente');
      _resetForm();
    } catch (e) {
      _showError('Error al agregar el vehículo: ${e.toString()}');
    }
  }
  void _resetForm() {
    setState(() {
      _patenteController.clear();
      _tecnicoController.clear();
      _commentController.clear();
      _formKey.currentState?.reset();
      _formValues.updateAll((key, value) => '');
      _editingVehicleIndex = -1;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de vehiculos')),
      drawer: NavBarWidget(
        pendingVehicles: _pendingVehicles,
        onEditVehicle: _handleEditVehicle,
        onDeleteVehicle: _handleDeleteVehicle,
        onSubmitAll: _submitAllVehicles,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              SearchAnchorWidget(
                hint: 'Patentes',
                suggestions: _patentes,
                formKey: 'patent',
                formValues: _formValues,
                controller: _patenteController,
                onItemSelected: (value) {
                  
                  setState(() => _formValues['patent'] = value);
                },
              ),
              const SizedBox(height: 20),
              SearchAnchorWidget(
                hint: 'Busca tecnico',
                suggestions: _tecnicos,
                formKey: 'technician',
                formValues: _formValues,
                controller: _tecnicoController,
                onItemSelected: (value) {
                  
                  setState(() => _formValues['technician'] = value);
                },
              ),

              const SizedBox(height: 20),
              DropdownWidget(
                label: 'Orden',
                options: _formOptions['cleanliness']!,
                formKey: 'order', 
                formValues: _formValues,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _formValues['order'] = value);
                  }
                },
              ),
              const SizedBox(height: 20),
              DropdownWidget(
                label: 'Limpieza',
                options: _formOptions['cleanliness']!,
                formKey: 'cleanliness',
                formValues: _formValues,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _formValues['cleanliness'] = value);
                  }
                },
              ),
              ..._buildYesNoFields(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comentario',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _formValues['comment'] = value,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addForm,
                child: const Text('AGREGAR', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildYesNoFields() {
    const fields = {
      'water': 'Agua',
      'spareTire': 'Rueda de auxilio',
      'oil': 'Aceite',
      'jack': 'Crique',
      'crossWrench': 'Llave cruz',
      'fireExtinguisher': 'Extinguidor',
      'lock': 'Candado',
    };

    return fields.entries.map((entry) => Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownWidget(
        label: entry.value,
        options: _formOptions['yesNo']!,
        formKey: entry.key,
        formValues: _formValues,
        onChanged: (value) {
          if (value != null) {
            setState(() => _formValues[entry.key] = value);
          }
        },
      ),
    )).toList();
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }



  void _handleEditVehicle(int index) {
    setState(() {
      Navigator.of(context).pop();
      _editingVehicleIndex = index;
      final vehicle = _pendingVehicles[index];

      _formValues = {
        'patent': vehicle.patent,
        'technician': vehicle.technician,
        'order': vehicle.order,
        'cleanliness': vehicle.cleanliness,
        'water': vehicle.water,
        'spareTire': vehicle.spareTire,
        'oil': vehicle.oil,
        'jack': vehicle.jack,
        'crossWrench': vehicle.crossWrench,
        'fireExtinguisher': vehicle.fireExtinguisher,
        'lock': vehicle.lock,
        'comment': vehicle.comment,
      };

      // Sincronizar controladores con los valores editados
      _patenteController.text = _formValues['patent']!;
      _tecnicoController.text = _formValues['technician']!;
      _commentController.text = _formValues['comment']!;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _formKey.currentState?.reset(); // Forzar revalidación del formulario
      }
    });
  }
  void _handleDeleteVehicle(int index) {
    setState(() {
      _pendingVehicles.removeAt(index);
      if (_editingVehicleIndex == index) {
        _resetForm();
      }
    });
  }


  Future<void> _submitAllVehicles() async {
    try {
      for (final vehicle in _pendingVehicles) {
        await _repository.save(vehicle);
      }

      _pendingVehicles.clear();
      _showSuccess('Todos los vehículos se han registrado correctamente.');
    } catch (e) {
      _showError('Error al registrar los vehículos: ${e.toString()}');
    }
  }

}

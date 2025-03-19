import 'dart:io';

import 'package:shared_models/shared_models.dart';
import 'package:carga_camionetas/Services/local_image_service.dart';
import 'package:carga_camionetas/Widgets/dropdown_widget.dart';
import 'package:carga_camionetas/Widgets/image_picker.dart';
import 'package:carga_camionetas/Widgets/nav_bar_widget.dart';
import 'package:carga_camionetas/Widgets/search_anchor_widget.dart';
import 'package:carga_camionetas/Widgets/snack_bar_widget.dart';
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
  // FocusNode _focusNode = FocusNode();

  List<Vehicle> _pendingVehicles = [];
  int _editingVehicleIndex = -1;
  final _formKey = GlobalKey<FormState>();
  final VehicleRepository _repository = VehicleRepository(FirebaseFirestore.instance);
  final _patenteController = TextEditingController();
  final _tecnicoController = TextEditingController();
  final _empresaController = TextEditingController();
  final _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  final LocalImageService _localImageService = LocalImageService();
  
  void _scrollToTop() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      0, 
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeInOut
    );
  }
}

  Map<String, String> _formValues = {
    'patent': '',
    'technician': '',
    'company': '',
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
  bool _isSending = false;
  List<String> _patentes = [];
  List<String> _tecnicos = [];
  List<String> _companies = [];

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
    _empresaController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final response = await rootBundle.loadString('assets/data.json');
      final data = json.decode(response) as Map<String, dynamic>;
      _patentes = List<String>.from(data['patentes']);
      _tecnicos = List<String>.from(data['tecnicos']);
      _companies = List<String>.from(data['empresas']);
    } catch (e) {
      if (mounted) {
        SnackBarWidget.showError(context, 'Error loading initial data');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }





  @override
Widget build(BuildContext context) {
  if (_isLoading) return const Center(child: CircularProgressIndicator());

  // Lista con los widgets de tu formulario, sin incluir SizedBox para espaciar.
  final formWidgets = <Widget>[
    if (_isSending)
        Center(
          child: CircularProgressIndicator(),
    ),
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
    SearchAnchorWidget(
      hint: 'Busca empresa',
      suggestions: _companies,
      formKey: 'company',
      formValues: _formValues,
      controller: _empresaController,
      onItemSelected: (value) {
        setState(() => _formValues['company'] = value);
      },
    ),
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
      prefixIcon: Icons.grid_view,
      prefixIconColor: Colors.deepOrange,
    ),
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
      prefixIcon: Icons.cleaning_services_outlined,
      prefixIconColor: Colors.brown,
    ),
    // Agregamos los campos de sí/no
    ..._buildYesNoFields(),
    ImagePickerWidget(
      onImagePicked: (File? image) {
        setState(() {
          _selectedImage = image;
        });
      },
    ),
    if (_selectedImage != null)
      Row(
        children: [
          const SizedBox(width: 10), // Espacio entre el icono y la imagen
          Image.file(
            _selectedImage!,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedImage = null;
              });
            },
          ),
        ],
    ),
    TextFormField(
      controller: _commentController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Comentario',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) => _formValues['comment'] = value,
    ),
    SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        onPressed: _addForm,
        child: const Text('AGREGAR', style: TextStyle(fontSize: 16)),
      ),
    ),
    
  ];

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text(
        'Registro de vehículos',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      elevation: 4,
      centerTitle: true,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    drawer: NavBarWidget(
      pendingVehicles: _pendingVehicles,
      onEditVehicle: _handleEditVehicle,
      onDeleteVehicle: _handleDeleteVehicle,
      onSubmitAll: _submitAllVehicles,
    ),
    body: SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: formWidgets
              .map((widget) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: widget,
                  ))
              .toList(),
        ),
      ),
    ),
  );
}




  List<Widget> _buildYesNoFields() {
    final fields = {
      'water': {'label': 'Agua', 'icon': Icons.water_drop, 'color': Colors.blue},
      'spareTire': {'label': 'Rueda de auxilio', 'icon': Icons.tire_repair, 'color': Colors.black},
      'oil': {'label': 'Aceite', 'icon': Icons.oil_barrel, 'color': Colors.green},
      'jack': {'label': 'Crique', 'icon': Icons.car_repair, 'color': Colors.orange},
      'crossWrench': {'label': 'Llave cruz', 'icon': Icons.build, 'color': Colors.black},
      'fireExtinguisher': {'label': 'Extintor', 'icon': Icons.fire_extinguisher, 'color': Colors.red},
      'lock': {'label': 'Candado', 'icon': Icons.lock, 'color': Color.fromRGBO(189, 165, 29, 1)},
    };

    return fields.entries.map((entry) => DropdownWidget(
      label: entry.value['label'] as String,
      options: _formOptions['yesNo']!,
      formKey: entry.key,
      formValues: _formValues,
      onChanged: (value) {
        if (value != null) {
          setState(() => _formValues[entry.key] = value);
        }
      },
      prefixIcon: entry.value['icon'] as IconData,
      prefixIconColor: entry.value['color'] as Color,
    )).toList();
  }




  void _handleEditVehicle(int index) async {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
    _editingVehicleIndex = index;
    
    final vehicle = _pendingVehicles[index];
    
    File? imageFile = await _localImageService.getImage(vehicle.localImagePath!);
    
    setState(() {
      _selectedImage = imageFile;
      _formValues = {
        'patent': vehicle.patent,
        'technician': vehicle.technician,
        'company': vehicle.company,
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
      _patenteController.text = _formValues['patent']!;
      _tecnicoController.text = _formValues['technician']!;
      _empresaController.text = _formValues['company']!;
      _commentController.text = _formValues['comment']!;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _formKey.currentState?.reset();
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
    Navigator.pop(context); 
    _scrollToTop();
    
    setState(() {
      _isSending = true;
    });

    
    try {
      for (final vehicle in _pendingVehicles) {
        if (vehicle.localImagePath != null) {
          final imageUrl = await SupabaseVehicleRepository.instance().save(vehicle.localImagePath!);
          vehicle.imageUrl = imageUrl; 
        }
        await _repository.save(vehicle);
      }

      if (mounted) {
        SnackBarWidget.showSuccess(context, 'Todos los vehículos se han registrado correctamente.');
      }

      _pendingVehicles.clear();

    } catch (e) {
      if (mounted) {
        SnackBarWidget.showError(context, 'Error al registrar los vehículos: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  Future<void> _addForm() async {
    FocusScope.of(context).requestFocus(FocusNode()); 


    Future.delayed(Duration(milliseconds: 100), () {
      _scrollToTop();
    });

    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen'), duration: Duration(milliseconds:300),),
      );
      return;
    }

    try {

      final String imagePath = await _localImageService.saveImage(_selectedImage!);

      final vehicle = Vehicle(
        date: Timestamp.now(),
        patent: _formValues['patent']!,
        technician: _formValues['technician']!,
        company: _formValues['company']!,
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
        localImagePath: imagePath,
        imageUrl: null,
      );


      if (_editingVehicleIndex >= 0) {
        _pendingVehicles[_editingVehicleIndex] = vehicle;
        _editingVehicleIndex = -1;
      } else {
        _pendingVehicles.add(vehicle);
      }
      if (mounted) {
        SnackBarWidget.showSuccess(context, 'Vehículo agregado exitosamente');
      }
      _resetForm();
    } catch (e) {
      if (mounted) {
        SnackBarWidget.showError(context, 'Error al agregar el vehículo: ${e.toString()}');
      }
    }
  }
  void _resetForm() {
    setState(() {
      _patenteController.clear();
      _tecnicoController.clear();
      _commentController.clear(); 
      _empresaController.clear(); 
      _formValues.updateAll((key, value) => ''); 
      _editingVehicleIndex = -1;
      _selectedImage = null;
    });
}
}




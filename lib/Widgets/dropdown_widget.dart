import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String label;
  final List<String> options;
  final String formKey;
  final Map<String, String> formValues;
  final Function(String?) onChanged;
  final IconData? prefixIcon;

  const DropdownWidget({
    Key? key,
    required this.label,
    required this.options,
    required this.formKey,
    required this.formValues,
    required this.onChanged,
    this.prefixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: formValues[formKey]!.isEmpty ? null : formValues[formKey],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
        border: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 3), 
        ),
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1), 
        ),
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 2), 
        ),
      ),
      items: options.map((option) => DropdownMenuItem(
        value: option,
        child: Text(
          option,
          style: TextStyle(color: Colors.black87),
        ),
      )).toList(),
      validator: (value) => value == null ? 'Este campo es requerido' : null,
      onChanged: onChanged,
      icon: const Icon(Icons.expand_more, color: Colors.black),
      iconSize: 24,
      dropdownColor: Colors.grey[200],
      style: TextStyle(color: Colors.black54),
      borderRadius: BorderRadius.circular(8),
      menuMaxHeight: 200,
      elevation: 2, // elevación del boton desplegable

    );
  }
}
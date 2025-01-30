import 'package:flutter/material.dart';


class DropdownWidget extends StatelessWidget {
  final String label;
  final List<String> options;
  final String formKey;
  final Map<String, String> formValues;
  final Function(String?) onChanged;

  const DropdownWidget({
    Key? key,
    required this.label,
    required this.options,
    required this.formKey,
    required this.formValues,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: formValues[formKey]!.isEmpty ? null : formValues[formKey],
      decoration: InputDecoration(labelText: label),
      items: options.map((option) => DropdownMenuItem(
        value: option,
        child: Text(option),
      )).toList(),
      validator: (value) => value == null ? 'Required field' : null,
      onChanged: onChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchFieldWidget extends StatelessWidget {
  final String hint;
  final List<String> suggestions;
  final String formKey;
  final Map<String, String> formValues;
  final Function(String) onItemSelected;

  const SearchFieldWidget({
    Key? key,
    required this.hint,
    required this.suggestions,
    required this.formKey,
    required this.formValues,
    required this.onItemSelected,
  }) : super(key: key);

  @override
Widget build(BuildContext context) {
  return SearchField<String>(
    suggestions: suggestions
        .map((s) => SearchFieldListItem<String>(s, item: s))
        .toList(),
    hint: hint,
    validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
    onSuggestionTap: (item) {
      if (item.item != null) {
        onItemSelected(item.item!);
      }
    },
  );
}
}

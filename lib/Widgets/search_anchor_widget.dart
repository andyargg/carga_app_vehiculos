import 'package:flutter/material.dart';

class SearchAnchorWidget extends StatefulWidget {
  final String hint;
  final List<String> suggestions;
  final String formKey;
  final Map<String, String> formValues;
  final Function(String) onItemSelected;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const SearchAnchorWidget({
    Key? key,
    required this.hint,
    required this.suggestions,
    required this.formKey,
    required this.formValues,
    required this.onItemSelected,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<SearchAnchorWidget> createState() => _SearchAnchorWidgetState();
}

class _SearchAnchorWidgetState extends State<SearchAnchorWidget> {
  late SearchController _searchController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
    widget.controller.addListener(_updateSearchController);
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.controller.removeListener(_updateSearchController);
    super.dispose();
  }

  void _updateSearchController() {
    if (_searchController.text != widget.controller.text) {
      _searchController.text = widget.controller.text;
      _validateInput(_searchController.text);
    }
  }

  String? _validateInput(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() => _errorText = error);
      return error;
    }

    if (value == null || value.isEmpty) {
      const error = 'Este campo es requerido';
      setState(() => _errorText = error);
      return error;
    }


    setState(() => _errorText = null);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.formValues[widget.formKey],
      validator: _validateInput,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchAnchor(
              searchController: _searchController,
              builder: (BuildContext context, SearchController searchController) {
                return SearchBar(
                  controller: searchController,
                  hintText: widget.hint,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          widget.controller.clear();
                          widget.onItemSelected('');
                          widget.formValues[widget.formKey] = '';
                          field.didChange('');
                          setState(() => _errorText = null);
                        },
                      ),
                  ],
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () {
                    searchController.openView();
                  },
                  onChanged: (value) {
                    widget.controller.text = value;
                    widget.formValues[widget.formKey] = value;
                    if (value.isEmpty) {
                      widget.onItemSelected('');
                    }
                    field.didChange(value);
                    _validateInput(value);
                  },
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController searchController) {
                final query = searchController.text.toLowerCase();
               

                final filteredSuggestions = widget.suggestions
                    .where((s) => s.toLowerCase().contains(query))
                    .toList();
                
                if (filteredSuggestions.isEmpty) {
                  return [
                    const ListTile(title: Text('No hay sugerencias disponibles'))
                  ];
                }
                
                return filteredSuggestions.map((s) => ListTile(
                  title: Text(s),
                  onTap: () {
                    widget.controller.text = s;
                    widget.formValues[widget.formKey] = s;
                    widget.onItemSelected(s);
                    field.didChange(s);
                    _validateInput(s);
                    searchController.closeView(s);
                  },
                )).toList();
              },
            ),
            if (_errorText != null || field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                child: Text(
                  _errorText ?? field.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.0,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
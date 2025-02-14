import 'package:flutter/material.dart';

class SearchAnchorWidget extends StatefulWidget {
  final String hint;
  final List<String> suggestions;
  final String formKey;
  final Map<String, String> formValues;
  final Function(String) onItemSelected;
  final TextEditingController controller;

  const SearchAnchorWidget({
    Key? key,
    required this.hint,
    required this.suggestions,
    required this.formKey,
    required this.formValues,
    required this.onItemSelected,
    required this.controller,
  }) : super(key: key);

  @override
  State<SearchAnchorWidget> createState() => _SearchAnchorWidgetState();
}

class _SearchAnchorWidgetState extends State<SearchAnchorWidget> {
  late SearchController _searchController;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          controller: searchController,
          hintText: widget.hint,
          leading: const Icon(Icons.search),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            searchController.openView();
          },
          onChanged: (value) {
            widget.controller.text = value;
            if (value.isEmpty) {
              widget.onItemSelected('');
            }
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
            widget.onItemSelected(s);
            searchController.closeView(s);
          },
        )).toList();
      },
    );
  }
}
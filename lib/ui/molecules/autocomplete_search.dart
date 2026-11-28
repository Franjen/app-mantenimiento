import 'package:material_ui/material_ui.dart';

class AutocompleteSearch extends StatelessWidget {
  final List<String> opciones;
  final ValueChanged<String> onChanged;
  const AutocompleteSearch({
    super.key,
    required this.opciones,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (value) => value.text.trim().isEmpty
          ? const Iterable<String>.empty()
          : opciones.where(
              (e) => e.toLowerCase().contains(value.text.trim().toLowerCase()),
            ),
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) =>
          TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: (_) => onSubmitted(),
            decoration: InputDecoration(
              hintText: 'Buscar equipo...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Limpiar',
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
    );
  }
}

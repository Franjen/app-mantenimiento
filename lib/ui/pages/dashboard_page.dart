import 'package:material_ui/material_ui.dart';

import '../../data/models/enums.dart';
import '../../data/models/mantenimiento_demo.dart';
import '../molecules/autocomplete_search.dart';
import '../organisms/mantenimiento_chart.dart';
import 'galeria_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final registros = List<MantenimientoDemo>.of(mantenimientosDemo);
  String busqueda = '';
  EstadoMantenimiento? filtro;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final abiertos = registros
        .where((e) => e.estado == EstadoMantenimiento.abierto)
        .length;
    final cerrados = registros.length - abiertos;
    final visibles = registros
        .where(
          (e) =>
              e.nombre.toLowerCase().contains(busqueda.trim().toLowerCase()) &&
              (filtro == null || e.estado == filtro),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento'),
        actions: [
          IconButton(
            tooltip: 'Galeria de diseno',
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const GaleriaPage())),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Panel de control',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'Resumen general de mantenimientos',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Datos de demostracion',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _indicador(
                        context,
                        'Abiertos',
                        abiertos,
                        Icons.schedule,
                        Colors.orange.shade800,
                      ),
                    ),
                    Expanded(
                      child: _indicador(
                        context,
                        'Cerrados',
                        cerrados,
                        Icons.check_circle_outline,
                        Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MantenimientoChart(abiertos: abiertos, cerrados: cerrados),
                const SizedBox(height: 24),
                Text(
                  'Buscar mantenimientos',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                AutocompleteSearch(
                  opciones: registros.map((e) => e.nombre).toList(),
                  onChanged: (v) => setState(() => busqueda = v),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Todos'),
                      selected: filtro == null,
                      onSelected: (_) => setState(() => filtro = null),
                    ),
                    for (final estado in EstadoMantenimiento.values)
                      ChoiceChip(
                        label: Text(estado.label),
                        selected: filtro == estado,
                        onSelected: (_) => setState(() => filtro = estado),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Resultados: ${visibles.length}',
                  style: theme.textTheme.titleMedium,
                ),
                if (visibles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No se encontraron equipos')),
                  ),
                for (final e in visibles)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.build_circle_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(e.nombre),
                      subtitle: Text('${e.tipo.label} - ${e.estado.label}'),
                      trailing: IconButton(
                        tooltip: e.estado == EstadoMantenimiento.abierto
                            ? 'Cerrar mantenimiento'
                            : 'Abrir mantenimiento',
                        icon: Icon(
                          e.estado == EstadoMantenimiento.abierto
                              ? Icons.check_circle_outline
                              : Icons.refresh,
                        ),
                        onPressed: () {
                          setState(() {
                            registros[registros.indexOf(e)] = e.cambiarEstado();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Estado actualizado correctamente'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _indicador(
    BuildContext context,
    String titulo,
    int cantidad,
    IconData icono,
    Color color,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icono, color: color, size: 28),
          Text(
            cantidad.toString(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(titulo),
        ],
      ),
    ),
  );
}

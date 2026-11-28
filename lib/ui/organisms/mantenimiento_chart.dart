import 'package:material_ui/material_ui.dart';
import 'package:fl_chart/fl_chart.dart';

class MantenimientoChart extends StatelessWidget {
  final int abiertos;
  final int cerrados;
  const MantenimientoChart({
    super.key,
    required this.abiertos,
    required this.cerrados,
  });
  @override
  Widget build(BuildContext context) {
    final total = abiertos + cerrados;
    final porcentaje = total == 0 ? 0.0 : abiertos * 100 / total;
    final porcentajeCerrado = total == 0 ? 0.0 : cerrados * 100 / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Estado de mantenimientos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (total > 0)
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 55,
                        sectionsSpace: 3,
                        sections: [
                          if (abiertos > 0)
                            PieChartSectionData(
                              value: abiertos.toDouble(),
                              color: Colors.orange.shade800,
                              radius: 38,
                              title: '${porcentaje.toStringAsFixed(1)}%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (cerrados > 0)
                            PieChartSectionData(
                              value: cerrados.toDouble(),
                              color: Colors.green.shade700,
                              radius: 38,
                              title: '${porcentajeCerrado.toStringAsFixed(1)}%',
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Text('Total'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                Chip(
                  avatar: Icon(Icons.circle, color: Colors.orange.shade800),
                  label: Text('Abiertos: $abiertos'),
                ),
                Chip(
                  avatar: Icon(Icons.circle, color: Colors.green.shade700),
                  label: Text('Cerrados: $cerrados'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

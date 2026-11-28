import 'package:app_mantenimiento/app.dart';
import 'package:app_mantenimiento/ui/organisms/mantenimiento_chart.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app inicia con Material 3 y Dashboard', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme?.useMaterial3, isTrue);
    expect(find.text('Panel de control'), findsOneWidget);
  });
  testWidgets('Grafico con cantidades iniciales correctas', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    final chart = tester.widget<MantenimientoChart>(
      find.byType(MantenimientoChart),
    );
    expect(chart.abiertos, 3);
    expect(chart.cerrados, 5);
  });
  testWidgets('Busqueda con autocompletado', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(TextField),
      150,
      scrollable: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    await tester.enterText(find.byType(TextField), 'Impresora');
    await tester.pumpAndSettle();
    expect(find.text('Impresora Epson'), findsWidgets);
    expect(find.text('Resultados: 1'), findsOneWidget);
  });
  testWidgets('Cambio de estado actualiza el grafico', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.descendant(
        of: find.ancestor(
          of: find.text('Impresora Epson'),
          matching: find.byType(ListTile),
        ),
        matching: find.byTooltip('Cerrar mantenimiento'),
      ),
      150,
      scrollable: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    await tester.ensureVisible(
      find.descendant(
        of: find.ancestor(
          of: find.text('Impresora Epson'),
          matching: find.byType(ListTile),
        ),
        matching: find.byTooltip('Cerrar mantenimiento'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('Impresora Epson'),
          matching: find.byType(ListTile),
        ),
        matching: find.byTooltip('Cerrar mantenimiento'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(MantenimientoChart),
      -150,
      scrollable: find.byWidgetPredicate(
        (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
      ),
    );
    final chart = tester.widget<MantenimientoChart>(
      find.byType(MantenimientoChart),
    );
    expect(chart.abiertos, 2);
    expect(chart.cerrados, 6);
  });
  testWidgets('La galeria anterior sigue disponible', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Galeria de diseno'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Galeria de diseno'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Galería de diseño'), findsOneWidget);
    expect(find.text('Átomos · Botón'), findsOneWidget);
  });
}

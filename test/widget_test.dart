import 'package:app_mantenimiento/app.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('la app arranca con el tema Material 3', (tester) async {
    await tester.pumpWidget(const App());

    // Verifica que la aplicación utilice Material 3.
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.theme?.useMaterial3, isTrue);

    // Verifica que se abra la galería de componentes.
    expect(find.text('Galería de diseño'), findsOneWidget);

    // Verifica que aparezca la sección de botones.
    expect(find.text('Átomos · Botón'), findsOneWidget);
  });
}

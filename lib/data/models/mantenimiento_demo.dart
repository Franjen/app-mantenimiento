import 'enums.dart';

class MantenimientoDemo {
  final String nombre;
  final TipoMantenimiento tipo;
  final EstadoMantenimiento estado;
  const MantenimientoDemo(this.nombre, this.tipo, this.estado);
  MantenimientoDemo cambiarEstado() => MantenimientoDemo(
    nombre,
    tipo,
    estado == EstadoMantenimiento.abierto
        ? EstadoMantenimiento.cerrado
        : EstadoMantenimiento.abierto,
  );
}

const mantenimientosDemo = <MantenimientoDemo>[
  MantenimientoDemo(
    'Computadora administrativa',
    TipoMantenimiento.preventivo,
    EstadoMantenimiento.cerrado,
  ),
  MantenimientoDemo(
    'Impresora Epson',
    TipoMantenimiento.correctivo,
    EstadoMantenimiento.abierto,
  ),
  MantenimientoDemo(
    'Servidor principal',
    TipoMantenimiento.preventivo,
    EstadoMantenimiento.cerrado,
  ),
  MantenimientoDemo(
    'Router de red',
    TipoMantenimiento.correctivo,
    EstadoMantenimiento.abierto,
  ),
  MantenimientoDemo(
    'Laptop de gerencia',
    TipoMantenimiento.preventivo,
    EstadoMantenimiento.cerrado,
  ),
  MantenimientoDemo(
    'Aire acondicionado',
    TipoMantenimiento.correctivo,
    EstadoMantenimiento.abierto,
  ),
  MantenimientoDemo(
    'Escaner de documentos',
    TipoMantenimiento.preventivo,
    EstadoMantenimiento.cerrado,
  ),
  MantenimientoDemo(
    'Switch de comunicaciones',
    TipoMantenimiento.preventivo,
    EstadoMantenimiento.cerrado,
  ),
];

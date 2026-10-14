
// Representa un vehículo con su valor y categoría.
class Vehiculo {
  final double valor;
  final int clave;

  const Vehiculo({
    required this.valor,
    required this.clave,
  });

  // Calcula el impuesto según la categoría del vehículo.
  double get impuesto {
    double porcentaje;

    switch (clave) {
      case 1:
        porcentaje = 0.10;
        break;
      case 2:
        porcentaje = 0.07;
        break;
      case 3:
        porcentaje = 0.05;
        break;
      default:
        throw ArgumentError('Categoría no válida');
    }

    // Redondeamos a dos decimales por tratarse de dinero.
    return (valor * porcentaje * 100).round() / 100;
  }
}

// Suma los impuestos de todos los vehículos.
// Si recibimos una clave, suma solamente esa categoría.
double calcularTotalImpuestos(
    List<Vehiculo> vehiculos, {
      int? clave,
    }) {
  double total = 0;

  for (final vehiculo in vehiculos) {
    if (clave == null || vehiculo.clave == clave) {
      total += vehiculo.impuesto;
    }
  }

  return (total * 100).round() / 100;
}

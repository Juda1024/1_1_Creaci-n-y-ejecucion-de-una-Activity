
// Calcula el ahorro acumulado sumando los depósitos.
double calcularAhorro(List<double> depositos) {
  double total = 0;

  // Recorremos todos los depósitos registrados.
  for (final deposito in depositos) {
    total += deposito;
  }

  return total;
}

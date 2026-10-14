
// Guarda los resultados calculados para cada cliente.
class ResultadoBanco {
  final double saldoActual;
  final double pagoMinimo;
  final double pagoSinIntereses;
  final double interes;
  final double multa;
  final bool esMoroso;

  const ResultadoBanco({
    required this.saldoActual,
    required this.pagoMinimo,
    required this.pagoSinIntereses,
    required this.interes,
    required this.multa,
    required this.esMoroso,
  });
}

// Calcula los valores correspondientes a un cliente.
ResultadoBanco calcularCliente({
  required double saldoAnterior,
  required double compras,
  required double pagoAnterior,
}) {
  // Calculamos el mínimo del corte anterior.
  final minimoAnterior = saldoAnterior * 0.15;

  // Saldo pendiente antes de aplicar recargos.
  final saldoBase = saldoAnterior + compras - pagoAnterior;

  // Determinamos si incumplió el pago mínimo.
  final esMoroso = pagoAnterior < minimoAnterior;

  double interes = 0;
  double multa = 0;

  // Solo los clientes morosos reciben recargos.
  if (esMoroso) {
    interes = saldoBase * 0.12;
    multa = 200;
  }

  // Calculamos el nuevo saldo y los pagos requeridos.
  final saldoActual = saldoBase + interes + multa;
  final pagoMinimo = saldoActual * 0.15;
  final pagoSinIntereses = saldoActual * 0.85;

  return ResultadoBanco(
    saldoActual: saldoActual,
    pagoMinimo: pagoMinimo,
    pagoSinIntereses: pagoSinIntereses,
    interes: interes,
    multa: multa,
    esMoroso: esMoroso,
  );
}


// Clase que realiza los cálculos del ejercicio 10.
class AnalizadorIntervalo {
  final double limiteInferior;
  final double limiteSuperior;

  // Variables que almacenan los resultados.
  double sumaDentro = 0;
  int cantidadFuera = 0;
  int cantidadIngresados = 0;
  bool ingresoIgualLimite = false;
  bool finalizado = false;

  // Recibimos los límites establecidos por el usuario.
  AnalizadorIntervalo({
    required this.limiteInferior,
    required this.limiteSuperior,
  });

  // Procesa cada número ingresado.
  void registrarNumero(double numero) {
    if (finalizado) return;

    // El cero termina el proceso y no se contabiliza.
    if (numero == 0) {
      finalizado = true;
      return;
    }

    cantidadIngresados++;

    // Comprobamos si está dentro del intervalo abierto.
    if (numero > limiteInferior && numero < limiteSuperior) {
      sumaDentro += numero;
    } else {
      cantidadFuera++;
    }

    // Verificamos si coincide con alguno de los límites.
    if (numero == limiteInferior ||
        numero == limiteSuperior) {
      ingresoIgualLimite = true;
    }
  }
}

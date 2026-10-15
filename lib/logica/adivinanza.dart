
import 'dart:math';

// Controla el número secreto y los intentos del jugador.
class JuegoAdivinanza {
  static const int maxIntentos = 10;

  // Genera un número aleatorio entre 1 y 100.
  final int _numeroSecreto = Random().nextInt(100) + 1;

  int intentosRealizados = 0;
  bool acertado = false;

  // Calcula cuántos intentos quedan.
  int get intentosRestantes => maxIntentos - intentosRealizados;

  // Determina si la partida terminó.
  bool get terminado =>
      acertado || intentosRealizados >= maxIntentos;

  // Comprueba el número ingresado y devuelve una pista.
  String comprobarNumero(int numero) {
    if (terminado) {
      return 'La partida ya terminó.';
    }

    intentosRealizados++;

    // Comprueba si el usuario acertó.
    if (numero == _numeroSecreto) {
      acertado = true;
      return '¡Correcto! Adivinaste el número '
          'en $intentosRealizados intentos.';
    }

    // Si agotó sus intentos, revela el número secreto.
    if (intentosRestantes == 0) {
      return '¡Se acabaron los intentos! '
          'El número secreto era $_numeroSecreto.';
    }

    // Indica si el número buscado es mayor o menor.
    if (numero < _numeroSecreto) {
      return 'El número secreto es MAYOR que $numero.';
    } else {
      return 'El número secreto es MENOR que $numero.';
    }
  }
}

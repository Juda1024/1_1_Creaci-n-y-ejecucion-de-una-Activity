
import 'package:flutter/material.dart';
import '../logica/adivinanza.dart';

// Pantalla del ejercicio 9.
// StatefulWidget permite actualizar los intentos y mensajes.
class Ejercicio9 extends StatefulWidget {
  const Ejercicio9({super.key});

  @override
  State<Ejercicio9> createState() => _Ejercicio9State();
}

class _Ejercicio9State extends State<Ejercicio9> {
  // Controla el número escrito por el usuario.
  final _numeroController = TextEditingController();

  // Crea una nueva partida.
  JuegoAdivinanza _juego = JuegoAdivinanza();

  String _mensaje = 'Ingresa un número para comenzar.';

  // Comprueba el número ingresado.
  void _intentar() {
    if (_juego.terminado) return;

    final numero = int.tryParse(
      _numeroController.text.trim(),
    );

    // Validamos que sea un entero entre 1 y 100.
    if (numero == null || numero < 1 || numero > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa un número entero entre 1 y 100.',
          ),
        ),
      );
      return;
    }

    // Actualizamos los resultados del juego.
    setState(() {
      _mensaje = _juego.comprobarNumero(numero);
    });

    _numeroController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Reinicia el juego generando otro número secreto.
  void _nuevaPartida() {
    setState(() {
      _juego = JuegoAdivinanza();
      _mensaje = 'Ingresa un número para comenzar.';
      _numeroController.clear();
    });
  }

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 9'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(
              Icons.casino,
              size: 65,
              color: Colors.indigo,
            ),

            const SizedBox(height: 12),

            const Text(
              'Adivina el número',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'He generado un número entre 1 y 100.\n'
                  'Tienes 10 intentos para adivinarlo.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Muestra los intentos realizados y restantes.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Intentos restantes: '
                          '${_juego.intentosRestantes}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Intentos realizados: '
                          '${_juego.intentosRealizados}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Solo permite ingresar números si sigue jugando.
            if (!_juego.terminado) ...[
              TextField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Ingresa un número',
                  hintText: 'Del 1 al 100',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                onSubmitted: (_) => _intentar(),
              ),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: _intentar,
                icon: const Icon(Icons.check),
                label: const Text('Comprobar número'),
              ),
            ],

            const SizedBox(height: 24),

            // Muestra las pistas o el resultado final.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      _juego.terminado
                          ? (_juego.acertado
                          ? Icons.emoji_events
                          : Icons.info)
                          : Icons.lightbulb_outline,
                      size: 45,
                      color: _juego.acertado
                          ? Colors.green
                          : Colors.indigo,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      _mensaje,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Al terminar, permite comenzar otra partida.
            if (_juego.terminado) ...[
              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: _nuevaPartida,
                icon: const Icon(Icons.refresh),
                label: const Text('Nueva partida'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

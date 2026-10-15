
import 'package:flutter/material.dart';
import '../logica/intervalos.dart';

// Pantalla del ejercicio 10.
// StatefulWidget permite actualizar los resultados.
class Ejercicio10 extends StatefulWidget {
  const Ejercicio10({super.key});

  @override
  State<Ejercicio10> createState() => _Ejercicio10State();
}

class _Ejercicio10State extends State<Ejercicio10> {
  // Controladores de los campos de texto.
  final _inferiorController = TextEditingController();
  final _superiorController = TextEditingController();
  final _numeroController = TextEditingController();

  // Almacena el análisis del intervalo.
  AnalizadorIntervalo? _analizador;

  // Convierte texto a número decimal.
  double? _leerNumero(String texto) {
    return double.tryParse(
      texto.trim().replaceAll(',', '.'),
    );
  }

  // Muestra un mensaje cuando existe un error.
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  // Verifica los límites y comienza el ejercicio.
  void _establecerIntervalo() {
    final inferior = _leerNumero(_inferiorController.text);
    final superior = _leerNumero(_superiorController.text);

    if (inferior == null ||
        superior == null ||
        !inferior.isFinite ||
        !superior.isFinite) {
      _mostrarError('Ingresa límites numéricos válidos.');
      return;
    }

    // El límite inferior no puede ser mayor al superior.
    if (inferior > superior) {
      _mostrarError(
        'El límite inferior no puede superar al superior.',
      );
      return;
    }

    // Creamos el analizador con los límites ingresados.
    setState(() {
      _analizador = AnalizadorIntervalo(
        limiteInferior: inferior,
        limiteSuperior: superior,
      );
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Registra cada número hasta recibir un cero.
  void _registrarNumero() {
    final numero = _leerNumero(_numeroController.text);

    if (numero == null || !numero.isFinite) {
      _mostrarError('Ingresa un número válido.');
      return;
    }

    // Actualizamos los cálculos y la pantalla.
    setState(() {
      _analizador!.registrarNumero(numero);
      _numeroController.clear();
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Permite comenzar un nuevo análisis.
  void _reiniciar() {
    setState(() {
      _analizador = null;
      _inferiorController.clear();
      _superiorController.clear();
      _numeroController.clear();
    });
  }

  // Muestra enteros sin decimales innecesarios.
  String _formatear(double numero) {
    if (numero == numero.truncateToDouble()) {
      return numero.toStringAsFixed(0);
    }
    return numero.toString();
  }

  // Crea campos numéricos reutilizables.
  Widget _campoNumero(
      String etiqueta,
      TextEditingController controlador,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controlador,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.numbers),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Liberamos los controladores al cerrar la pantalla.
    _inferiorController.dispose();
    _superiorController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 10'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Análisis de intervalos',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Ingresa los límites de un intervalo '
                  'y registra números hasta introducir cero.',
            ),

            const SizedBox(height: 24),

            // Primero solicitamos los límites del intervalo.
            if (_analizador == null) ...[
              _campoNumero(
                'Límite inferior',
                _inferiorController,
              ),

              _campoNumero(
                'Límite superior',
                _superiorController,
              ),

              FilledButton.icon(
                onPressed: _establecerIntervalo,
                icon: const Icon(Icons.check),
                label: const Text('Establecer intervalo'),
              ),
            ],

            // Una vez establecidos los límites, ingresamos números.
            if (_analizador != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Intervalo establecido',
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '(${_formatear(_analizador!.limiteInferior)}, '
                            '${_formatear(_analizador!.limiteSuperior)})',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Números registrados: '
                            '${_analizador!.cantidadIngresados}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Seguimos solicitando números mientras no ingrese cero.
              if (!_analizador!.finalizado) ...[
                const Text(
                  'Ingresar número',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _campoNumero(
                  'Número',
                  _numeroController,
                ),

                FilledButton.icon(
                  onPressed: _registrarNumero,
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar número'),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Introduce 0 para finalizar y ver los resultados.',
                  textAlign: TextAlign.center,
                ),
              ],

              // Al ingresar cero, mostramos los resultados.
              if (_analizador!.finalizado) ...[
                const Text(
                  'Resultados finales',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Suma dentro del intervalo:',
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          _formatear(_analizador!.sumaDentro),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(height: 25),

                        Text(
                          'Números fuera del intervalo: '
                              '${_analizador!.cantidadFuera}',
                          style: const TextStyle(fontSize: 16),
                        ),

                        const Divider(height: 25),

                        Text(
                          '¿Se ingresó algún número igual '
                              'a los límites?',
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _analizador!.ingresoIgualLimite
                              ? 'Sí'
                              : 'No',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _analizador!.ingresoIgualLimite
                                ? Colors.green
                                : Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Permite realizar otro ejercicio desde cero.
              OutlinedButton.icon(
                onPressed: _reiniciar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

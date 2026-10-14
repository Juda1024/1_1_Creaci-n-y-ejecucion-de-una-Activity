
import 'package:flutter/material.dart';
import '../logica/ahorro.dart';

// Pantalla del ejercicio 8.
// StatefulWidget permite actualizar los ahorros mensuales.
class Ejercicio8 extends StatefulWidget {
  const Ejercicio8({super.key});

  @override
  State<Ejercicio8> createState() => _Ejercicio8State();
}

class _Ejercicio8State extends State<Ejercicio8> {
  // Meses del año.
  final List<String> _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  // Controlador del campo de ingreso.
  final _depositoController = TextEditingController();

  // Lista donde guardamos los depósitos.
  final List<double> _depositos = [];

  // Registra el depósito correspondiente al mes actual.
  void _registrarDeposito() {
    if (_depositos.length >= 12) return;

    final texto = _depositoController.text
        .trim()
        .replaceAll(',', '.');

    final deposito = double.tryParse(texto);

    // Validamos que el depósito no sea negativo.
    if (deposito == null ||
        !deposito.isFinite ||
        deposito < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa una cantidad válida.'),
        ),
      );
      return;
    }

    // Guardamos el depósito y actualizamos la pantalla.
    setState(() {
      _depositos.add(deposito);
      _depositoController.clear();
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Reinicia el ejercicio desde enero.
  void _reiniciar() {
    setState(() {
      _depositos.clear();
      _depositoController.clear();
    });
  }

  // Formatea los valores monetarios.
  String _moneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    _depositoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Comprobamos si se registraron los doce meses.
    final terminado = _depositos.length == 12;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 8'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Ahorro anual',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Ingresa la cantidad de dinero que '
                  'ahorras al finalizar cada mes.',
            ),

            const SizedBox(height: 24),

            // Mostramos el formulario hasta completar el año.
            if (!terminado) ...[
              Text(
                'Mes: ${_meses[_depositos.length]}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _depositoController,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Cantidad a depositar',
                  hintText: 'Ejemplo: 150',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _registrarDeposito(),
              ),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: _registrarDeposito,
                icon: const Icon(Icons.add),
                label: const Text('Registrar depósito'),
              ),

              const SizedBox(height: 20),
            ],

            // Muestra el ahorro acumulado hasta el momento.
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Ahorro acumulado',
                      style: TextStyle(fontSize: 17),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _moneda(calcularAhorro(_depositos)),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Meses registrados: ${_depositos.length}/12',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Historial de depósitos y acumulados.
            if (_depositos.isNotEmpty) ...[
              const Text(
                'Historial de ahorro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              for (int i = 0; i < _depositos.length; i++)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.savings),

                    title: Text(_meses[i]),

                    subtitle: Text(
                      'Depósito: ${_moneda(_depositos[i])}\n'
                          'Acumulado: ${_moneda(
                        calcularAhorro(
                          _depositos.sublist(0, i + 1),
                        ),
                      )}',
                    ),
                  ),
                ),
            ],

            // Mensaje final cuando termina diciembre.
            if (terminado) ...[
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 45,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        '¡Año completado!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Total ahorrado: '
                            '${_moneda(calcularAhorro(_depositos))}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Botón para comenzar un nuevo registro anual.
            if (_depositos.isNotEmpty) ...[
              const SizedBox(height: 20),

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

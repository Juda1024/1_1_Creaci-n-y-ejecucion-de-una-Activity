
import 'package:flutter/material.dart';
import '../logica/banco.dart';

// Pantalla del ejercicio 7.
// StatefulWidget permite actualizar clientes y resultados.
class Ejercicio7 extends StatefulWidget {
  const Ejercicio7({super.key});

  @override
  State<Ejercicio7> createState() => _Ejercicio7State();
}

class _Ejercicio7State extends State<Ejercicio7> {
  // Controladores para los datos ingresados.
  final _cantidadController = TextEditingController();
  final _saldoController = TextEditingController();
  final _comprasController = TextEditingController();
  final _pagoController = TextEditingController();

  int? _cantidadClientes;

  // Guardamos los resultados y acumulamos los intereses.
  final List<ResultadoBanco> _resultados = [];
  double _totalIntereses = 0;

  // Muestra mensajes cuando los datos no son válidos.
  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  // Establece cuántos clientes vamos a procesar.
  void _iniciar() {
    final cantidad = int.tryParse(
      _cantidadController.text.trim(),
    );

    if (cantidad == null || cantidad <= 0) {
      _mostrarError('Ingresa una cantidad válida de clientes.');
      return;
    }

    setState(() {
      _cantidadClientes = cantidad;
      _resultados.clear();
      _totalIntereses = 0;
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Convierte el texto ingresado en un número decimal.
  double? _leerMonto(TextEditingController controlador) {
    return double.tryParse(
      controlador.text.trim().replaceAll(',', '.'),
    );
  }

  // Procesa un cliente utilizando la lógica de banco.dart.
  void _registrarCliente() {
    final saldo = _leerMonto(_saldoController);
    final compras = _leerMonto(_comprasController);
    final pago = _leerMonto(_pagoController);

    // Validamos que los montos sean correctos.
    if (saldo == null ||
        compras == null ||
        pago == null ||
        !saldo.isFinite ||
        !compras.isFinite ||
        !pago.isFinite ||
        saldo < 0 ||
        compras < 0 ||
        pago < 0 ||
        pago > saldo + compras) {
      _mostrarError('Revisa los montos ingresados.');
      return;
    }

    // Calculamos los resultados del cliente.
    final resultado = calcularCliente(
      saldoAnterior: saldo,
      compras: compras,
      pagoAnterior: pago,
    );

    setState(() {
      _resultados.add(resultado);

      // Acumulamos solo intereses, no multas.
      _totalIntereses += resultado.interes;

      // Limpiamos los campos para el siguiente cliente.
      _saldoController.clear();
      _comprasController.clear();
      _pagoController.clear();
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  // Permite comenzar nuevamente con otros clientes.
  void _reiniciar() {
    setState(() {
      _cantidadClientes = null;
      _resultados.clear();
      _totalIntereses = 0;

      _cantidadController.clear();
      _saldoController.clear();
      _comprasController.clear();
      _pagoController.clear();
    });
  }

  // Formato de dinero con dos decimales.
  String _moneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }

  // Campo reutilizable para evitar repetir código.
  Widget _campoMonto(
      String etiqueta,
      TextEditingController controlador,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controlador,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: etiqueta,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.attach_money),
        ),
      ),
    );
  }

  // Crea una tarjeta con los resultados de cada cliente.
  Widget _tarjetaResultado(int indice) {
    final resultado = _resultados[indice];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente ${indice + 1} - '
                  '${resultado.esMoroso ? "Moroso" : "No moroso"}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Saldo actual: ${_moneda(resultado.saldoActual)}',
            ),
            Text(
              'Pago mínimo (15%): '
                  '${_moneda(resultado.pagoMinimo)}',
            ),
            Text(
              'Pago sin intereses (85%): '
                  '${_moneda(resultado.pagoSinIntereses)}',
            ),
            Text(
              'Interés: ${_moneda(resultado.interes)}',
            ),
            Text(
              'Multa: ${_moneda(resultado.multa)}',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Liberamos los controladores al cerrar la pantalla.
    _cantidadController.dispose();
    _saldoController.dispose();
    _comprasController.dispose();
    _pagoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 7'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Banco Bandido de Peluche',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Calcula el saldo actual y los pagos '
                  'correspondientes a cada cliente.',
            ),

            const SizedBox(height: 24),

            // Primero solicitamos la cantidad de clientes.
            if (_cantidadClientes == null) ...[
              TextField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de clientes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
              ),

              const SizedBox(height: 16),

              FilledButton(
                onPressed: _iniciar,
                child: const Text('Comenzar'),
              ),
            ],

            // Formulario y resultados del procesamiento.
            if (_cantidadClientes != null) ...[
              Text(
                'Clientes procesados: '
                    '${_resultados.length} de $_cantidadClientes',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Pedimos los datos mientras falten clientes.
              if (_resultados.length < _cantidadClientes!) ...[
                Text(
                  'Datos del cliente ${_resultados.length + 1}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                _campoMonto(
                  'Saldo anterior',
                  _saldoController,
                ),

                _campoMonto(
                  'Compras realizadas',
                  _comprasController,
                ),

                _campoMonto(
                  'Pago anterior',
                  _pagoController,
                ),

                FilledButton.icon(
                  onPressed: _registrarCliente,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calcular cliente'),
                ),

                const SizedBox(height: 20),
              ],

              // Mostramos los resultados obtenidos.
              if (_resultados.isNotEmpty) ...[
                const Text(
                  'Resultados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                for (int i = 0; i < _resultados.length; i++)
                  _tarjetaResultado(i),
              ],

              // Al terminar, mostramos los intereses totales.
              if (_resultados.length == _cantidadClientes) ...[
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Proceso finalizado',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Total ganado por intereses: '
                              '${_moneda(_totalIntereses)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              OutlinedButton(
                onPressed: _reiniciar,
                child: const Text('Reiniciar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

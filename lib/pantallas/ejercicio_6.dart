
import 'package:flutter/material.dart';
import '../logica/impuestos.dart';

// Pantalla del ejercicio 6.
// StatefulWidget permite actualizar la lista y los resultados.
class Ejercicio6 extends StatefulWidget {
  const Ejercicio6({super.key});

  @override
  State<Ejercicio6> createState() => _Ejercicio6State();
}

class _Ejercicio6State extends State<Ejercicio6> {
  // Controla el campo donde ingresamos el valor.
  final TextEditingController _valorController =
  TextEditingController();

  // Almacena los vehículos registrados.
  final List<Vehiculo> _vehiculos = [];

  // Categoría seleccionada inicialmente.
  int _claveSeleccionada = 1;

  // Agrega un vehículo después de validar su valor.
  void _agregarVehiculo() {
    final texto = _valorController.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(texto);

    if (valor == null || !valor.isFinite || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un valor válido mayor que cero.'),
        ),
      );
      return;
    }

    // setState actualiza la pantalla con el nuevo vehículo.
    setState(() {
      _vehiculos.add(
        Vehiculo(
          valor: valor,
          clave: _claveSeleccionada,
        ),
      );

      _valorController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  // Elimina un vehículo registrado.
  void _eliminarVehiculo(int indice) {
    setState(() {
      _vehiculos.removeAt(indice);
    });
  }

  // Formatea los resultados con dos decimales.
  String _moneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }

  // Libera el controlador cuando se cierra la pantalla.
  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 6'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Impuestos de vehículos',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Registra los vehículos de la compañía '
                  'para calcular sus impuestos.',
            ),

            const SizedBox(height: 24),

            // Campo para ingresar el valor del automóvil.
            TextField(
              controller: _valorController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor del vehículo (\$)',
                hintText: 'Ejemplo: 15000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              onSubmitted: (_) => _agregarVehiculo(),
            ),

            const SizedBox(height: 16),

            // Selector de las tres categorías de impuestos.
            Row(
              children: [
                const Text(
                  'Categoría:',
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: DropdownButton<int>(
                    value: _claveSeleccionada,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Clave 1 - 10%'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('Clave 2 - 7%'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('Clave 3 - 5%'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          _claveSeleccionada = valor;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón para registrar un vehículo.
            FilledButton.icon(
              onPressed: _agregarVehiculo,
              icon: const Icon(Icons.add),
              label: const Text('Agregar vehículo'),
            ),

            const SizedBox(height: 25),

            Text(
              'Vehículos registrados: ${_vehiculos.length}',
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Mensaje si todavía no existen vehículos.
            if (_vehiculos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Todavía no has registrado vehículos.',
                  textAlign: TextAlign.center,
                ),
              ),

            // Muestra cada vehículo y su impuesto.
            for (int i = 0; i < _vehiculos.length; i++)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car),

                  title: Text(
                    'Vehículo ${i + 1} - Clave ${_vehiculos[i].clave}',
                  ),

                  subtitle: Text(
                    'Valor: ${_moneda(_vehiculos[i].valor)}\n'
                        'Impuesto: ${_moneda(_vehiculos[i].impuesto)}',
                  ),

                  // Permite corregir registros eliminándolos.
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Eliminar vehículo',
                    onPressed: () => _eliminarVehiculo(i),
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // Resumen de impuestos por categoría.
            const Text(
              'Resumen de impuestos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clave 1 (10%): '
                          '${_moneda(calcularTotalImpuestos(_vehiculos, clave: 1))}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Clave 2 (7%): '
                          '${_moneda(calcularTotalImpuestos(_vehiculos, clave: 2))}',
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Clave 3 (5%): '
                          '${_moneda(calcularTotalImpuestos(_vehiculos, clave: 3))}',
                    ),

                    const Divider(height: 25),

                    Text(
                      'TOTAL GENERAL: '
                          '${_moneda(calcularTotalImpuestos(_vehiculos))}',
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
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

// Pantalla principal con los accesos a los cinco ejercicios.
class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarea 2.1 - NRC 36873'),
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
        centerTitle: true,
      ),

      // ListView permite desplazar el contenido.
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(
              Icons.menu_book,
              size: 65,
              color: Colors.indigo,
            ),

            const SizedBox(height: 12),

            const Text(
              'Menú de ejercicios',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Selecciona el ejercicio que deseas realizar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            crearOpcion(
              context,
              'Ejercicio 6',
              'Impuestos de vehículos',
              Icons.directions_car,
              '/ejercicio6',
            ),

            crearOpcion(
              context,
              'Ejercicio 7',
              'Cálculos bancarios',
              Icons.account_balance,
              '/ejercicio7',
            ),

            crearOpcion(
              context,
              'Ejercicio 8',
              'Ahorro anual',
              Icons.savings,
              '/ejercicio8',
            ),

            crearOpcion(
              context,
              'Ejercicio 9',
              'Adivina el número',
              Icons.casino,
              '/ejercicio9',
            ),

            crearOpcion(
              context,
              'Ejercicio 10',
              'Análisis de intervalos',
              Icons.calculate,
              '/ejercicio10',
            ),
          ],
        ),
      ),
    );
  }

  // Crea una tarjeta reutilizable y recibe la ruta de destino.
  Widget crearOpcion(
      BuildContext context,
      String titulo,
      String descripcion,
      IconData icono,
      String ruta,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          icono,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),

        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(descripcion),

        trailing: const Icon(Icons.arrow_forward_ios),

        // Abre la pantalla asociada mediante una ruta.
        onTap: () {
          Navigator.pushNamed(context, ruta);
        },
      ),
    );
  }
}

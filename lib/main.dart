
import 'package:flutter/material.dart';

import 'pantallas/menu_principal.dart';
import 'pantallas/ejercicio_6.dart';
import 'pantallas/ejercicio_7.dart';
import 'pantallas/ejercicio_8.dart';
import 'pantallas/ejercicio_9.dart';
import 'pantallas/ejercicio_10.dart';

// Inicia la aplicación Flutter.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 2.1 - NRC 36873',
      debugShowCheckedModeBanner: false,

      // Configuración del diseño general.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      // Pantalla que aparece al iniciar la aplicación.
      home: const MenuPrincipal(),

      // Rutas que conectan el menú con cada ejercicio.
      routes: {
        '/ejercicio6': (context) => const Ejercicio6(),
        '/ejercicio7': (context) => const Ejercicio7(),
        '/ejercicio8': (context) => const Ejercicio8(),
        '/ejercicio9': (context) => const Ejercicio9(),
        '/ejercicio10': (context) => const Ejercicio10(),
      },
    );
  }
}

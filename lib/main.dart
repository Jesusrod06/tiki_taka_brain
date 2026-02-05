import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa tu lógica (el cerebro)
import 'game_logic.dart'; 

// Importa tu pantalla de inicio (la cara)
// NOTA: Si tu archivo está en la carpeta 'screens', deja esta línea. 
// Si está suelto en 'lib', bórrala y pon: import 'home_screen.dart';
import 'screens/home_screen.dart'; 

void main() {
  runApp(
    // Inyectamos el cerebro (MemoryGameController) a toda la app
    ChangeNotifierProvider(
      create: (context) => MemoryGameController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta "Debug" de la esquina
      title: 'Tiki Taka Brain',
      theme: ThemeData(
        // Usamos un tema oscuro para que resalten los colores neón
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 10, 14, 33),
        useMaterial3: true,
      ),
      // Aquí es donde le decimos qué mostrar primero:
      home: const HomeScreen(), 
    );
  }
}
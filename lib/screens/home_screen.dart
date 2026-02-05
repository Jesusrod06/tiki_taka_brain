import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_logic.dart'; 
import 'game_board.dart';    

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology, 
              size: 100, 
              color: Colors.greenAccent
            ),
            const SizedBox(height: 20),
            const Text(
              'TIKI-TAKA\nBRAIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 50),

            // Botón Modo Solo
            _buildMenuButton(
              context, 
              label: 'SOLO MODE', 
              isMulti: false, 
              color: Colors.greenAccent
            ),

            const SizedBox(height: 20),

            // Botón Modo Versus
            _buildMenuButton(
              context, 
              label: 'VERSUS (2P)', 
              isMulti: true, 
              color: Colors.blueAccent
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, {required String label, required bool isMulti, required Color color}) {
    return SizedBox(
      width: 250,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // 1. Inicializamos la lógica en el Provider
          Provider.of<MemoryGameController>(context, listen: false).initializeGame(isMulti);

          // 2. Navegamos al tablero pasándole el parámetro obligatorio
          Navigator.push(
            context,
            MaterialPageRoute(
              // AQUÍ ESTABA EL ERROR: Ahora le pasamos 'isMultiplayer' al GameBoard
              builder: (context) => GameBoard(isMultiplayer: isMulti), 
            ),
          );
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.black
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../game_logic.dart';

class GameBoard extends StatelessWidget {
  // Recibimos el parámetro para saber si es versus o solo
  final bool isMultiplayer; 

  const GameBoard({super.key, required this.isMultiplayer});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryGameController>(
      builder: (context, game, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E21), // Fondo oscuro
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: _buildHeader(game), // Marcador de puntos
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              // Configuración de la cuadrícula 6x6
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,       // 6 columnas obligatorias
                childAspectRatio: 0.7,   // Cartas más altas que anchas para que quepa el texto
                crossAxisSpacing: 5,     // Espacio horizontal entre cartas
                mainAxisSpacing: 5,      // Espacio vertical entre cartas
              ),
              itemCount: game.cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => game.onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      // Color: Blanco si está volteada, Verde neón si está oculta
                      color: game.cardFlips[index] || game.cardMatched[index]
                          ? Colors.white
                          : Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: game.cardFlips[index] || game.cardMatched[index]
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FittedBox(
                                // --- EL SECRETO ---
                                // Esto obliga al texto a encogerse hasta que quepa
                                fit: BoxFit.scaleDown, 
                                child: Text(
                                  game.cards[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Tamaño base (se reducirá si es necesario)
                                  ),
                                ),
                              ),
                            )
                          : const Icon( // Icono para la parte trasera de la carta
                              Icons.sports_soccer, 
                              color: Colors.black26, 
                              size: 20
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Widget para mostrar el marcador (Tiempo o Puntos P1 vs P2)
  Widget _buildHeader(MemoryGameController game) {
    if (isMultiplayer) {
      // Marcador Jugador 1 vs Jugador 2
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'P1: ${game.p1Score}',
            style: TextStyle(
              color: game.currentPlayer == 1 ? Colors.greenAccent : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('VS', style: TextStyle(color: Colors.white, fontSize: 14)),
          Text(
            'P2: ${game.p2Score}',
            style: TextStyle(
              color: game.currentPlayer == 2 ? Colors.blueAccent : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      // Marcador Modo Solo: Tiempo y Score
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '⏳ ${game.timeLeft}s',
            style: TextStyle(
              color: game.timeLeft < 10 ? Colors.red : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'PTS: ${game.score}',
            style: const TextStyle(color: Colors.yellowAccent),
          ),
        ],
      );
    }
  }
}
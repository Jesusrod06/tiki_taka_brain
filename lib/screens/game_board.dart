import 'package:flutter/material.dart';
import '../game_logic.dart';

class GameBoard extends StatefulWidget {
  final bool isMultiplayer;
  const GameBoard({super.key, required this.isMultiplayer});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late MemoryGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MemoryGameController();
    _controller.initializeGame(widget.isMultiplayer);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_controller.isMultiplayer ? "Duelo 1vs1" : "Tiempo: ${_controller.timeLeft}s"),
            backgroundColor: const Color(0xFF0038A8),
            foregroundColor: Colors.white,
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // El requisito de la Unimet
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 36,
            itemBuilder: (context, index) {
              bool isFlipped = _controller.cardFlips[index] || _controller.cardMatched[index];
              return GestureDetector(
                onTap: () => _controller.onCardTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isFlipped ? Colors.white : const Color(0xFF0038A8),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE8541E)),
                  ),
                  child: Center(
                    child: isFlipped 
                      ? Text(_controller.cards[index].substring(0, 3), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))
                      : const Icon(Icons.help_outline, color: Colors.white, size: 16),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
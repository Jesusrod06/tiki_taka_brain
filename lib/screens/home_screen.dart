import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryGameController extends ChangeNotifier {
  final List<String> _allPlayers = [
    'Messi', 'CR7', 'Mbappé', 'Haaland', 'Vini Jr', 'Bellingham',
    'Neymar', 'Salah', 'De Bruyne', 'Lewandowski', 'Kane', 'Rodri',
    'Modric', 'Kroos', 'Griezmann', 'Bruno F.', 'Son', 'Osimhen'
  ];

  List<String> cards = [];
  List<bool> cardFlips = [];
  List<bool> cardMatched = [];
  int? firstIndex;
  bool isProcessing = false;
  
  int score = 0;
  int attempts = 0; 
  int highScore = 0;
  bool isMultiplayer = false;
  int currentPlayer = 1; 
  int p1Score = 0;
  int p2Score = 0;
  
  Timer? _timer;
  int timeLeft = 60;
  bool isGameOver = false;

  MemoryGameController() { loadHighScore(); }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners(); 
  }

  Future<void> saveHighScore(int newScore) async {
    final prefs = await SharedPreferences.getInstance();
    if (newScore > highScore) {
      highScore = newScore;
      await prefs.setInt('highScore', highScore);
    }
  }

  void initializeGame(bool multi) {
    isMultiplayer = multi;
    cards = [..._allPlayers, ..._allPlayers];
    cards.shuffle();
    cardFlips = List.generate(36, (index) => false);
    cardMatched = List.generate(36, (index) => false);
    attempts = 0; score = 0; p1Score = 0; p2Score = 0;
    currentPlayer = 1; isGameOver = false; isProcessing = false;
    firstIndex = null; timeLeft = multi ? 0 : 90;
    if (_timer != null) _timer!.cancel();
    if (!isMultiplayer) startTimer();
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0 && !isGameOver) {
        timeLeft--;
        notifyListeners();
      } else {
        isGameOver = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void onCardTap(int index) {
    if (isProcessing || cardFlips[index] || cardMatched[index] || isGameOver) return;
    cardFlips[index] = true;
    notifyListeners();
    if (firstIndex == null) {
      firstIndex = index;
    } else {
      isProcessing = true;
      attempts++;
      checkMatch(firstIndex!, index);
    }
  }

  void checkMatch(int index1, int index2) {
    if (cards[index1] == cards[index2]) {
      cardMatched[index1] = true;
      cardMatched[index2] = true;
      isProcessing = false;
      firstIndex = null;
      if (isMultiplayer) {
        currentPlayer == 1 ? p1Score++ : p2Score++;
      } else {
        score += 10 + (timeLeft ~/ 5);
      }
      checkWinCondition();
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        cardFlips[index1] = false;
        cardFlips[index2] = false;
        if (isMultiplayer) currentPlayer = currentPlayer == 1 ? 2 : 1;
        isProcessing = false;
        firstIndex = null;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void checkWinCondition() {
    if (cardMatched.every((element) => element)) {
      isGameOver = true;
      if (_timer != null) _timer!.cancel();
      if (!isMultiplayer) saveHighScore(score);
    }
    notifyListeners();
  }
}
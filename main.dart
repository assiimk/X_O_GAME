import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> _boardState = List.filled(9, "");
  String _currentPlayer = "X";
  String _winner = "";
  int _timeRemaining = 10;
  Timer? _timer;

  void _handleCellTap(int index) {
    if (_boardState[index].isEmpty && _winner.isEmpty) {
      setState(() {
        _boardState[index] = _currentPlayer;
        _currentPlayer = _currentPlayer == "X" ? "O" : "X";
        _checkWinner();
        _resetTimer();
      });
    }
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (_boardState[i] == _boardState[i + 1] &&
          _boardState[i] == _boardState[i + 2] &&
          _boardState[i].isNotEmpty) {
        setState(() {
          _winner = _boardState[i];
        });
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_boardState[i] == _boardState[i + 3] &&
          _boardState[i] == _boardState[i + 6] &&
          _boardState[i].isNotEmpty) {
        setState(() {
          _winner = _boardState[i];
        });
        return;
      }
    }

    // Check diagonals
    if (_boardState[0] == _boardState[4] &&
        _boardState[0] == _boardState[8] &&
        _boardState[0].isNotEmpty) {
      setState(() {
        _winner = _boardState[0];
      });
      return;
    }
    if (_boardState[2] == _boardState[4] &&
        _boardState[2] == _boardState[6] &&
        _boardState[2].isNotEmpty) {
      setState(() {
        _winner = _boardState[2];

      });
      return;
    }

    // Check for draw
    if (!_boardState.contains("")) {
      setState(() {
        _winner = "Draw";
      });
    }
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, "");
      _currentPlayer = "X";
      _winner = "";
      _timeRemaining = 10;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _handleTimeout();
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _timeRemaining = 10;
    _startTimer();
  }

  void _handleTimeout() {
    setState(() {
      _winner = _currentPlayer == "X" ? "O" : "X";
    });
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("X - O Game"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        children: [
          // Time Remaining at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Time Remaining: $_timeRemaining",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleCellTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        _boardState[index],
                        style: TextStyle(
                          fontSize: 48,
                          color: _boardState[index] == "X" ? Colors.blue : Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Current Player: $_currentPlayer",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _winner.isNotEmpty ? "Winner: $_winner" : "",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text("Reset Game"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

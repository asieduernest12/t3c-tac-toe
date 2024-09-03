import 'package:flutter/material.dart';

class T3cTacToeGame extends StatefulWidget {
  const T3cTacToeGame({super.key});

  @override
  State<T3cTacToeGame> createState() => _T3cTacToeGameState();
}

class _T3cTacToeGameState extends State<T3cTacToeGame> {
  List<List<String>>? _board;

  bool? _isXNext = true;

  void _initializeBoard() {
    setState(
      () {
        _board = List.generate(3, (i) => List.generate(3, (j) => ''));
        _isXNext = true;
      },
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  bool _checkWinner(int row, int col) {
    List<List<int>> winningCombo = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    List<String> cells = _board!.expand((element) => element).toList();

    // return winningCombo.any(([a,b,c]) =>  (cells[a] == cells[b] && cells[b] == cells[c] && c != ''));
    return winningCombo.any((combo) {
      final a = combo[0];
      final b = combo[1];
      final c = combo[2];
      return cells[a] == cells[b] && cells[b] == cells[c] && cells[a] != '';
    });
  }

  bool _isBoardFull() {
    return !_board!
        .expand((element) => element)
        .any((element) => element.isEmpty);
  }

  void _handleTap(int row, int col) {
    if (_board![row][col].isEmpty) {
      setState(() {
        _board![row][col] = _isXNext! ? 'X' : 'O';
        _isXNext = !_isXNext!;
      });

      if (_checkWinner(row, col)) {
        _showDialog('${_board?[row][col]} Wins!', 'Congratulations');
        _initializeBoard();
      } else if (_isBoardFull()) {
        _showDialog('It\'s a draw', 'Try again');
        _initializeBoard();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft),
          ),
        ),
        title: const Text("T3c - Tac - Toe"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isXNext! ? 'Player X\'s turn' : 'Player O\'s turn',
                style: const TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16.0,
              ),
              AspectRatio(
                aspectRatio: 1.0,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return GestureDetector(
                      onTap: () => _handleTap(row, col),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text(
                            _board![row][col],
                            style: const TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

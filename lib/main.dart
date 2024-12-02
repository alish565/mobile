import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(GuessingGameApp());

class GuessingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GuessingGame(),
    );
  }
}

class GuessingGame extends StatefulWidget {
  @override
  _GuessingGameState createState() => _GuessingGameState();
}

class _GuessingGameState extends State<GuessingGame> {
  final int minNum = 1;
  final int maxNum = 100;
  late int answer;
  int attempts = 0;
  final TextEditingController guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    answer = Random().nextInt(maxNum - minNum + 1) + minNum;
    attempts = 0;
  }

  void _checkGuess(String input) {
    int? guess = int.tryParse(input);

    if (guess == null) {
      _showAlert("Invalid Input", "Please enter a valid number.");
      return;
    }

    if (guess < minNum || guess > maxNum) {
      _showAlert("Out of Range", "Please guess a number between $minNum and $maxNum.");
      return;
    }

    setState(() {
      attempts++;
      if (guess < answer) {
        _showAlert("Too Low", "Your guess is too low. Try again!");
      } else if (guess > answer) {
        _showAlert("Too High", "Your guess is too high. Try again!");
      } else {
        _showAlert(
          "Correct!",
          "The answer was $answer. It took you $attempts attempts.",
          onDismiss: () {
            _resetGame();
            setState(() {});
          },
        );
      }
    });
  }

  void _showAlert(String title, String message, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,style: TextStyle(fontSize: 25),),
        content: Text(message,style: TextStyle(fontSize: 18),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onDismiss != null) onDismiss();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Guess the Number", style: TextStyle(color: Colors.white)),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Guess a number between $minNum and $maxNum",
              style: TextStyle(fontSize: 35, color: Colors.white),
              textAlign: TextAlign.center,

            ),
            SizedBox(height: 16, width: 50,),

              SizedBox(width: 200.0, height: 50.0,
                child:TextField(
              controller: guessController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Your Guess",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _checkGuess(guessController.text);
                guessController.clear();
              },
              child: Text("Enter", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

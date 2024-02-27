import 'package:flutter/material.dart';
import 'package:mp2/views/yahtzee.dart';

class FinalScoreDialog extends StatelessWidget {
  final int finalScore;
  final VoidCallback onPlayAgain;

  FinalScoreDialog({
    required this.finalScore,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game Over'),
      content: Text('Final Score: $finalScore'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Yahtzee(),
              ),
            );
          },
          child: Text('Play Again'),
        ),
      ],
    );
  }
}

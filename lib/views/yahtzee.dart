import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/models/final_model.dart';
import 'package:mp2/models/random_number_display.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Yahtzee'),
          backgroundColor: Colors.cyan,
        ),
        backgroundColor: Colors.cyan[100],
        body: ChangeNotifierProvider(
          create: (context) => FinalScoreModel(),
          child: RandomNumberDisplay(),
        ),
      ),
    );
  }
}

class SquareBoxWithBorder extends StatelessWidget {
  final int? number;
  final bool isHeld;

  SquareBoxWithBorder(this.number, this.isHeld);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isHeld ? Colors.red : Colors.cyan,
          width: 2.0,
        ),
      ),
      margin: EdgeInsets.all(10),
      child: Center(
        child: Text(
          number != null ? '$number' : '',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ScoreCategoryButton extends StatelessWidget {
  final ScoreCategory category;
  final VoidCallback onPressed;
  final int? score;

  ScoreCategoryButton({
    required this.category,
    required this.onPressed,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final isUsed = score != null;

    return Column(
      children: [
        Container(
          width: 150,
          height: 25,
          decoration: BoxDecoration(
            color: isUsed ? Colors.red : Colors.cyan,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: Text(category.name),
          ),
        ),
        Text(
          category.description,
          style: TextStyle(fontSize: 12),
        ),
        Text(
          'Score: ${score ?? 0}',
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/models/final_score_dialog.dart';
import 'package:mp2/models/final_model.dart';
import 'package:mp2/views/yahtzee.dart';

class RandomNumberDisplay extends StatefulWidget {
  @override
  _RandomNumberDisplayState createState() => _RandomNumberDisplayState();
}

class _RandomNumberDisplayState extends State<RandomNumberDisplay> {
  final Dice dice = Dice(5);
  bool shouldUpdateNumbers = true;
  int buttonPressCount = 0;
  bool outOfRolls = false;
  final ScoreCard scoreCard = ScoreCard();

  void generateRandomNumbers() {
    outOfRolls = false;
    if (buttonPressCount < 3) {
      setState(() {
        if (shouldUpdateNumbers) {
          dice.roll();
        }
      });

      buttonPressCount++;
    }
    if (buttonPressCount == 3) {
      setState(() {
        // Set a flag to indicate that rolls are out
        outOfRolls = true;
      });
    }
  }

  void toggleUpdateNumbers() {
    setState(() {
      shouldUpdateNumbers = !shouldUpdateNumbers;
      buttonPressCount = 0;
    });
  }

  void toggleHoldState(int index) {
    setState(() {
      dice.toggleHold(index);
    });
  }

  void handleScoring(ScoreCategory category, FinalScoreModel finalScoreModel) {
    final diceValues = dice.values;
    scoreCard.registerScore(category, diceValues);

    setState(() {
      shouldUpdateNumbers = true;
      buttonPressCount = 0;
      outOfRolls = false;
      dice.clear();
    });

    if (scoreCard.completed) {
      finalScoreModel.setFinalScore(scoreCard.total);
      finalScoreDialog(context, finalScoreModel);
      scoreCard.clear();
    }
  }

  void finalScoreDialog(BuildContext context, FinalScoreModel finalScoreModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FinalScoreDialog(
          finalScore: finalScoreModel.finalScore,
          onPlayAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Yahtzee(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ScoreCategory.values;
    final mid = (categories.length / 2).ceil();
    final leftColumn = categories.take(mid);
    final rightColumn = categories.skip(mid);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < dice.values.length; i++)
                GestureDetector(
                  onTap: () {
                    toggleHoldState(i);
                  },
                  child: SquareBoxWithBorder(dice[i], dice.isHeld(i)),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: generateRandomNumbers,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
            ),
            child: Text(
              outOfRolls ? 'Out of rolls!' : 'Roll (${buttonPressCount + 1})',
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  for (var category in leftColumn)
                    ScoreCategoryButton(
                      category: category,
                      onPressed: () {
                        if (dice.values.isNotEmpty) {
                          handleScoring(
                              category, context.read<FinalScoreModel>());
                        }
                      },
                      score: scoreCard[category],
                    ),
                ],
              ),
              Column(
                children: [
                  for (var category in rightColumn)
                    ScoreCategoryButton(
                      category: category,
                      onPressed: () {
                        if (dice.values.isNotEmpty) {
                          handleScoring(
                              category, context.read<FinalScoreModel>());
                        }
                      },
                      score: scoreCard[category],
                    ),
                ],
              ),
            ],
          ),
          Text('Total Score: ${scoreCard.total}'),
        ],
      ),
    );
  }
}

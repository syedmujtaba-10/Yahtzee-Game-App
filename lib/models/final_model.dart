import 'package:flutter/foundation.dart';

class FinalScoreModel extends ChangeNotifier {
  int _finalScore = 0;

  int get finalScore => _finalScore;

  void setFinalScore(int score) {
    _finalScore = score;
    notifyListeners();
  }
}

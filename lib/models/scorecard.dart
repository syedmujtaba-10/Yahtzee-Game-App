import 'package:collection/collection.dart';

enum ScoreCategory {
  ones("Ones"),
  twos("Twos"),
  threes("Threes"),
  fours("Fours"),
  fives("Fives"),
  sixes("Sixes"),
  threeOfAKind("Three of a Kind"),
  fourOfAKind("Four of a Kind"),
  fullHouse("Full House"),
  smallStraight("Small Straight"),
  largeStraight("Large Straight"),
  yahtzee("Yahtzee"),
  chance("Chance");

  const ScoreCategory(this.name);

  final String name;

  // Add descriptions for each category
  String get description {
    switch (this) {
      case ScoreCategory.ones:
        return 'Sum of all ones';
      case ScoreCategory.twos:
        return 'Sum of all twos';
      case ScoreCategory.threes:
        return 'Sum of all threes';
      case ScoreCategory.fours:
        return 'Sum of all fours';
      case ScoreCategory.fives:
        return 'Sum of all fives';
      case ScoreCategory.sixes:
        return 'Sum of all sixes';
      case ScoreCategory.threeOfAKind:
        return 'Total of all dice if at least three are the same';
      case ScoreCategory.fourOfAKind:
        return 'Total of all dice if at least four are the same';
      case ScoreCategory.fullHouse:
        return '25 points if three of one number and two of another';
      case ScoreCategory.smallStraight:
        return '30 points for a sequence of four';
      case ScoreCategory.largeStraight:
        return '40 points for a sequence of five';
      case ScoreCategory.yahtzee:
        return '50 points if all five dice are the same';
      case ScoreCategory.chance:
        return 'Total of all dice';
    }
  }
}

class ScoreCard {
  final Map<ScoreCategory, int?> _scores = {
    for (var category in ScoreCategory.values) category: null
  };

  int? operator [](ScoreCategory category) => _scores[category];

  bool get completed => _scores.values.whereNotNull().length == _scores.length;

  int get total => _scores.values.whereNotNull().sum;

  void clear() {
    _scores.forEach((key, value) {
      _scores[key] = null;
    });
  }

  void registerScore(ScoreCategory category, List<int> dice) {
    final uniqueVals = Set.from(dice);

    if (_scores[category] != null) {
      throw Exception('Category $category already has a score');
    }

    switch (category) {
      case ScoreCategory.ones:
        _scores[category] = dice.where((d) => d == 1).sum;
        break;

      case ScoreCategory.twos:
        _scores[category] = dice.where((d) => d == 2).sum;
        break;

      case ScoreCategory.threes:
        _scores[category] = dice.where((d) => d == 3).sum;
        break;

      case ScoreCategory.fours:
        _scores[category] = dice.where((d) => d == 4).sum;
        break;

      case ScoreCategory.fives:
        _scores[category] = dice.where((d) => d == 5).sum;
        break;

      case ScoreCategory.sixes:
        _scores[category] = dice.where((d) => d == 6).sum;
        break;

      case ScoreCategory.threeOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 3)) {
          _scores[category] = dice.sum;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.fourOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 4)) {
          _scores[category] = dice.sum;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.fullHouse:
        if (uniqueVals.length == 2 &&
            uniqueVals.any((d) => dice.where((d2) => d2 == d).length == 3)) {
          _scores[category] = 25;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.smallStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4]) ||
            uniqueVals.containsAll([2, 3, 4, 5]) ||
            uniqueVals.containsAll([3, 4, 5, 6])) {
          _scores[category] = 30;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.largeStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4, 5]) ||
            uniqueVals.containsAll([2, 3, 4, 5, 6])) {
          _scores[category] = 40;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.yahtzee:
        if (dice.length == 5 && uniqueVals.length == 1) {
          _scores[category] = 50;
        } else {
          _scores[category] = 0;
        }
        break;

      case ScoreCategory.chance:
        _scores[category] = dice.sum;
        break;
    }
  }
}

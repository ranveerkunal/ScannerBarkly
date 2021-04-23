import 'dart:math';

import 'package:flutter/material.dart';

class TileSelector extends ChangeNotifier {
  static final rand = Random();
  final Set<int> valid;
  final Set<int> visible = Set.of([143, 144]);
  final Set<int> tiers = Set.of([]);
  bool _blink = true;
  bool get blink => _blink;
  int _rank = 0;
  int get rank => _rank;

  TileSelector(this.valid);

  int random() {
    return next(() => rand.nextInt(145));
  }

  int select(int rank) {
    if (!valid.contains(rank)) {
      return random();
    }
    _rank = rank;
    notifyListeners();
    return rank;
  }

  void toggleTier(int tier) {
    tiers.contains(tier) ? tiers.remove(tier) : tiers.add(tier);
    notifyListeners();
  }

  int next(int Function() lambda) {
    for (int i = 0; i < 10; i++) {
      final rank = lambda();
      if (!valid.contains(rank)) continue;
      _rank = rank;
      notifyListeners();
      return rank;
    }
    return 1;
  }
}

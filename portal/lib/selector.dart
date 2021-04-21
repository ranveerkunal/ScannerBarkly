import 'dart:math';

import 'package:flutter/material.dart';

class TileSelector extends ChangeNotifier {
  static final rand = Random();
  final Set<int> valid;
  final Set<int> visible = Set.of([143, 144]);
  bool _blink = true;
  bool get blink => _blink;
  int _rank = 0;
  int get rank => _rank;
  int _tier = -1;
  int get tier => _tier;

  TileSelector(this.valid);

  void random() {
    next(() => rand.nextInt(144));
  }

  void select(int rank) {
    if (!valid.contains(rank)) return;
    _rank = rank;
    notifyListeners();
  }

  void selectTier(int tier) {
    _tier = tier;
    notifyListeners();
  }

  void next(int Function() lambda) {
    for (int i = 0; i < 10; i++) {
      final rank = lambda();
      if (!valid.contains(rank)) continue;
      _rank = rank;
      notifyListeners();
      return;
    }
  }

  void filter(Set<int> keep) => visible
    ..clear()
    ..addAll(keep);

  void unfilter() => visible
    ..clear()
    ..addAll([143, 144]);
}

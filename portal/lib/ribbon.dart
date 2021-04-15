import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:provider/provider.dart';

class Ribbon extends StatelessWidget {
  final double girth;
  final Orientation orientation;
  final Color? color;

  Ribbon({
    required this.girth,
    required this.orientation,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.read<Config>();
    return orientation == Orientation.landscape
        ? Column(
            children: color != null
                ? [Container(height: girth, color: color)]
                : List<int>.generate(7, (i) => i + 1)
                    .map((tier) => Container(
                          height: (girth / 32 * (tier < 7 ? 5 : 2)),
                          color: config.colorOfTier(tier),
                        ))
                    .toList(),
          )
        : Row(
            children: color != null
                ? [Container(width: girth, color: color)]
                : List<int>.generate(7, (i) => i + 1)
                    .map((tier) => Container(
                          width: (girth / 32 * (tier < 7 ? 5 : 2)),
                          color: config.colorOfTier(tier),
                        ))
                    .toList(),
          );
  }
}

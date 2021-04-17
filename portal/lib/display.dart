import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:portal/ribbon.dart';
import 'package:portal/tile.dart';
import 'package:provider/provider.dart';

class Display extends StatelessWidget {
  final double size;

  Display({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ValueNotifier<Selected?>>();
    if (selected.value == null) return Container();
    final config = context.read<Config>();
    final rank = selected.value!.rank;
    final tc = config.tiles[rank]!;
    final scale = context.read<double>();
    return Container(
      color: config.palette['7'],
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            top: 140 * scale,
            bottom: (140 + 32) * scale,
            child: Ribbon(
              girth: 32 * scale,
              orientation: Orientation.landscape,
              color: config.palette['0'],
            ),
          ),
          Positioned.fill(
            left: 140 * scale,
            right: (140 + 32) * scale,
            child: Ribbon(
              girth: 32 * scale,
              orientation: Orientation.portrait,
              color: config.palette['0'],
            ),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Image(
              image: selected.value!.img,
              gaplessPlayback: true,
              fit: BoxFit.cover,
              height: 420 * scale,
              width: 420 * scale,
            ),
          ),
          Positioned(
            left: 32,
            top: 32,
            child: Text(
              'ScannerBarkly',
              style: TextStyle(color: config.palette['0']),
            ),
          ),
          Positioned(
            top: 32,
            child: Text(
              tc.name,
              style: TextStyle(color: config.palette['${tc.tier}']),
            ),
          ),
        ],
      ),
    );
  }
}

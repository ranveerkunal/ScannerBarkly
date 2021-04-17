import 'package:flutter/material.dart';
import 'package:portal/config.dart';
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
      alignment: Alignment.center,
      height: size,
      width: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40 * scale,
            alignment: Alignment.center,
            child: Text(
              tc.name,
              style: TextStyle(color: config.palette['7']),
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
          Container(
            height: 40 * scale,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

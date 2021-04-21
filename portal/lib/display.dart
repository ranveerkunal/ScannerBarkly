import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:portal/selector.dart';
import 'package:provider/provider.dart';

class Display extends StatelessWidget {
  final double size;

  Display({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selector = context.watch<TileSelector>();
    final rank = selector.selected;
    final asset = context.watch<Map<int, TileAsset>>()[rank]!;
    if (asset.img == null) return Container();
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
            child: Text('${asset.config.name} #${asset.config.rank}'),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Image(
              image: asset.img!,
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

import 'package:flutter/material.dart';

import 'package:portal/config.dart';
import 'package:portal/opensea.dart';
import 'package:portal/ribbon.dart';
import 'package:portal/selector.dart';
import 'package:portal/tile.dart';
import 'package:provider/provider.dart';

class Collage extends StatelessWidget {
  final CollectionModel model;

  Collage(this.model);

  @override
  Widget build(BuildContext context) {
    final scale = context.read<double>();
    final config = context.read<Config>();
    final model = context.watch<CollectionModel>();
    final selector = context.read<TileSelector>();
    return Container(
      height: 500 * scale,
      width: 500 * scale,
      color: context.read<Config>().bg,
      child: Stack(
        children: [
          Positioned.fill(
            top: 140 * scale,
            bottom: (140 + 32) * scale,
            child: Ribbon(
              girth: 32 * scale,
              orientation: Orientation.landscape,
            ),
          ),
          Positioned.fill(
            left: 140 * scale,
            right: (140 + 32) * scale,
            child: Ribbon(
              girth: 32 * scale,
              orientation: Orientation.portrait,
            ),
          ),
          Positioned(
            top: 40 * scale,
            left: 40 * scale,
            child: Container(
              height: 420 * scale,
              width: 420 * scale,
              child: TheGrid(config, model),
            ),
          ),
          Positioned(
            bottom: 5 * scale,
            right: 40 * scale,
            child: Container(
              height: 35 * scale,
              width: 35 * 6 * scale,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List<int>.generate(6, (i) => i + 1).map(
                    (i) {
                      return GestureDetector(
                        onTap: () => selector.toggleTier(i),
                        child: Container(
                          height: 20 * scale,
                          width: 20 * scale,
                          decoration: BoxDecoration(
                            color: config.palette['$i'],
                            shape: BoxShape.circle,
                            border: selector.tiers.contains(i)
                                ? Border.all(
                                    width: 2 * scale,
                                    color: config.palette['7']!,
                                    style: BorderStyle.solid,
                                  )
                                : null,
                          ),
                        ),
                      );
                    },
                  ).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class TheGrid extends StatelessWidget {
  final Config config;
  final CollectionModel model;

  const TheGrid(this.config, this.model);

  @override
  Widget build(BuildContext context) {
    final tiles = List<int>.generate(12, (i) => i)
        .map((r) => r % 2 == 0
            ? List<int>.generate(12, (c) => 12 * r + c + 1)
            : List<int>.generate(12, (c) => 12 * r + c + 1).reversed)
        .expand((i) => i);
    return GridView.count(
      primary: false,
      crossAxisCount: 12,
      children: tiles.map((i) {
        final tc = config.tiles[i];
        return tc == null
            ? Container(color: config.bg)
            : GestureTile(
                key: ValueKey<int>(tc.rank),
                asset: model.getAsset(tc.id),
                config: tc,
              );
      }).toList(),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:portal/selector.dart';
import 'package:provider/provider.dart';

class Tile extends StatefulWidget {
  final TileConfig config;
  final ImageProvider? img;
  final bool visible;

  Tile(this.config, this.img, this.visible);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  static final rand = Random(420);

  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: rand.nextInt(12))).then(
      (value) {
        timer = Timer.periodic(
          Duration(seconds: 3),
          (t) => setState(() => index = rand.nextInt(12) == 0 ? 1 : 0),
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Container(color: widget.config.bg);
    final fg = widget.img != null
        ? Image(image: widget.img!, gaplessPlayback: true)
        : bg;
    if (widget.visible) index = 1;
    return AnimatedSwitcher(
      duration: Duration(seconds: 3),
      child: [bg, fg][index],
    );
  }
}

class GestureTile extends StatefulWidget {
  final Map<String, dynamic>? asset;
  final TileConfig config;

  GestureTile({Key? key, required this.asset, required this.config})
      : super(key: key);

  @override
  _GestureTileState createState() => _GestureTileState();
}

class _GestureTileState extends State<GestureTile> {
  ImageProvider? img;

  @override
  void didUpdateWidget(covariant GestureTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset != null) {
      img = NetworkImage(widget.asset!['image_url']);
    } else if (widget.config.rank == 143) {
      img = AssetImage('data/cover.jpg');
    } else if (widget.config.rank == 144) {
      img = AssetImage('data/logo.jpg');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (img != null) precacheImage(img!, context);
  }

  @override
  Widget build(BuildContext context) {
    final selector = context.watch<TileSelector>();
    final rank = widget.config.rank;
    final tier = widget.config.tier;
    final fg = widget.config.fg;
    return GestureDetector(
      onTap: () => selector.select(rank),
      child: Stack(
        children: [
          Tile(
            widget.config,
            img,
            selector.visible.contains(rank) || selector.tiers.contains(tier),
          ),
          if (selector.rank == rank)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: fg, //context.read<Config>().palette['$tier']!,
                  width: 32 * context.watch<double>() / 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

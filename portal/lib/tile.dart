import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:provider/provider.dart';

class Tile extends StatefulWidget {
  final TileConfig config;
  final ImageProvider? img;

  Tile(this.config, this.img);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  static final rand = Random(420);

  int index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.config.rank < 143) {
      Future.delayed(Duration(seconds: rand.nextInt(12))).then(
        (value) {
          return Timer.periodic(
            Duration(seconds: 3),
            (t) => setState(() => index = rand.nextInt(12) == 0 ? 1 : 0),
          );
        },
      );
    } else {
      index = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = Container(color: widget.config.bg);
    final fg = widget.img != null
        ? Image(
            image: widget.img!,
            gaplessPlayback: true,
          )
        : bg;
    return AnimatedSwitcher(
      duration: Duration(seconds: 3),
      child: [bg, fg][index],
    );
  }
}

class Selected {
  final int rank;
  final ImageProvider img;

  Selected(this.rank, this.img);
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
    if (widget.config.rank == 144 && img != null) {
      final selected = context.read<ValueNotifier<Selected?>>();
      Timer.run(() {
        if (selected.value == null) selected.value = Selected(144, img!);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (img != null) precacheImage(img!, context);
  }

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ValueNotifier<Selected?>>();
    final hover = selected.value?.rank == widget.config.rank;
    final tier = widget.config.tier;
    return GestureDetector(
      onTap: () => selected.value = Selected(widget.config.rank, img!),
      child: Stack(
        children: [
          Tile(widget.config, img),
          if (hover)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.read<Config>().palette['$tier']!,
                  width: 32 * context.watch<double>() / 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

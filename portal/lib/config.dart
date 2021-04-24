import 'dart:convert';
import 'dart:ui';

import 'package:color_models/color_models.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:portal/opensea.dart';

Color bgrToColor(bgr) => Color.fromRGBO(bgr[2], bgr[1], bgr[0], 1.0);

class TileAsset {
  final TileConfig config;
  final Map<String, dynamic>? asset;
  final ImageProvider? img;

  factory TileAsset(TileConfig config, CollectionModel model) {
    final asset = model.getAsset(config.id);
    ImageProvider? img;
    if (asset != null) {
      img = NetworkImage(asset['image_url']);
    } else if (config.rank == 143) {
      img = AssetImage('data/cover.jpg');
    } else if (config.rank == 144) {
      img = AssetImage('data/logo.jpg');
    }
    return TileAsset._(config, asset, img);
  }

  TileAsset._(this.config, this.asset, this.img);
}

class TileConfig {
  final int rank;
  final String name;
  final int tier;
  final String wiki;
  final String opensea;
  final String orig;
  final int id;
  final Color bg;
  final Color fg;

  static Color fgFromBg(Color bg) {
    final rgb = RgbColor(bg.red, bg.green, bg.blue);
    final lab = rgb.toLabColor();
    final delta = lab.lightness > 50 ? -50 : 50;
    final fg = LabColor(lab.lightness + delta, lab.a, lab.b).toRgbColor();
    return Color.fromRGBO(fg.red, fg.green, fg.blue, 1.0);
  }

  TileConfig(final contract, final tmap)
      : rank = tmap['rank'],
        name = tmap['id'] != null ? tmap['id'][2] : tmap['name'],
        tier = tmap['tier'],
        wiki = p.join('https://en.wikipedia.org', tmap['wiki']),
        opensea = tmap['id'] != null
            ? p.join('https://opensea.io/assets', contract, tmap['id'][1])
            : '',
        orig = 'https://${tmap["img"]}',
        id = tmap['id'] != null ? tmap['id'][0] : 0,
        bg = bgrToColor(tmap['bgr']),
        fg = fgFromBg(bgrToColor(tmap['bgr']));

  @override
  String toString() {
    return 'rank: $rank, name: $name, tier: $tier, id: $id';
  }
}

class Config {
  final String contract;
  final String slug;
  final Map<int, TileConfig> tiles;
  final Map<String, Color> palette;
  final Color bg;

  Color colorOfTier(int tier) {
    if (tier > 7) tier = 7;
    return palette['$tier'] ?? bg;
  }

  factory Config(final String configJson) {
    final tmap = json.decode(configJson);
    final contract = tmap['contract'];
    final tiles = (tmap['tiles'] as List).map(
      (t) => MapEntry(t['rank'] as int, TileConfig(contract, t)),
    );
    final palette = (tmap['colors'] as Map).map(
      (k, v) => MapEntry(k as String, bgrToColor(v)),
    );
    return Config._(
      contract,
      tmap['slug'],
      Map.fromEntries(tiles),
      palette,
      palette['bg'] ?? bgrToColor([255, 0, 0]),
    );
  }

  Config._(this.contract, this.slug, this.tiles, this.palette, this.bg);

  @override
  String toString() {
    return 'contract: $contract, slug: $slug, palette: $palette';
  }
}

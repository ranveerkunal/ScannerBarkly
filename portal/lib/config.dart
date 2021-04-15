import 'dart:convert';
import 'dart:ui';

import 'package:path/path.dart' as p;

Color bgrToColor(bgr) => Color.fromRGBO(bgr[2], bgr[1], bgr[0], 1.0);

class TileConfig {
  final int rank;
  final String name;
  final int tier;
  final String wiki;
  final String orig;
  final int id;
  final Color bg;

  TileConfig(final tmap)
      : rank = tmap['rank'],
        name = tmap['id'] != null ? tmap['id'][2] : tmap['name'],
        tier = tmap['tier'],
        wiki = p.join('https://en.wikipedia.org', tmap['wiki']),
        orig = 'https://${tmap["img"]}',
        id = tmap['id'] != null ? tmap['id'][0] : 0,
        bg = bgrToColor(tmap['bgr']);

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
    final tiles = (tmap['tiles'] as List).map(
      (t) => MapEntry(t['rank'] as int, TileConfig(t)),
    );
    final palette = (tmap['colors'] as Map).map(
      (k, v) => MapEntry(k as String, bgrToColor(v)),
    );
    return Config._(
      tmap['contract'],
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

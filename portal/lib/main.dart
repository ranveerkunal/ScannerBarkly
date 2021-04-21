import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:portal/collage.dart';
import 'package:portal/config.dart';
import 'package:portal/display.dart';
import 'package:portal/opensea.dart';
import 'package:portal/selector.dart';
import 'package:provider/provider.dart';

void main() async {
  print('Woof.. Woof...');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(Config(await rootBundle.loadString('data/config.json'))));
}

class MyApp extends StatelessWidget {
  final Config config;
  final CollectionModel model;
  final TileSelector selector;

  MyApp(this.config)
      : model = CollectionModel(config.slug),
        selector = TileSelector(Set.from(config.tiles.keys))..random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScannerBarkly',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
      ),
      home: MultiProvider(
        providers: [
          Provider.value(value: config),
          ChangeNotifierProvider.value(value: model),
          ProxyProvider2<Config, CollectionModel, Map<int, TileAsset>>(
            update: (_, config, model, __) => config.tiles.map(
              (rank, tc) => MapEntry(rank, TileAsset(tc, model)),
            ),
          ),
          ChangeNotifierProvider.value(value: selector),
        ],
        child: Builder(builder: (BuildContext context) => MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final model = context.watch<CollectionModel>();
    final config = context.read<Config>();
    final children = [
      Provider<double>.value(
        value: max(ss.height, ss.width) / 1000,
        child: Container(
          height: max(ss.height, ss.width) / 2,
          width: max(ss.height, ss.width) / 2,
          child: Display(
            key: ValueKey<int>(context.watch<TileSelector>().selected),
            size: max(ss.height, ss.width) / 2,
          ),
        ),
      ),
      Provider<double>.value(
        value: max(ss.height, ss.width) / 1000,
        child: Collage(model),
      ),
    ];
    return Scaffold(
      body: Container(
        color: config.palette['bg']!,
        child: Center(
          child: ss.width > ss.height
              ? Row(
                  children: children,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              : Column(
                  children: children,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
        ),
      ),
    );
  }
}

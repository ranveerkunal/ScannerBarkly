import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:portal/collage.dart';
import 'package:portal/config.dart';
import 'package:portal/display.dart';
import 'package:portal/opensea.dart';
import 'package:portal/tile.dart';
import 'package:provider/provider.dart';

void main() async {
  print('Woof.. Woof...');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(Config(await rootBundle.loadString('data/config.json'))));
}

class MyApp extends StatelessWidget {
  final Config config;
  final CollectionModel model;
  final ValueNotifier<Selected?> selected = ValueNotifier<Selected?>(null);

  MyApp(this.config) : model = CollectionModel(config.slug);

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: config,
      child: MaterialApp(
        title: 'ScannerBarkly',
        theme: ThemeData(
          primarySwatch: createMaterialColor(config.bg),
          textTheme: GoogleFonts.robotoMonoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: ChangeNotifierProvider.value(
          value: model,
          child: ChangeNotifierProvider.value(
            value: selected,
            child: Builder(builder: (BuildContext context) => MyHomePage()),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final bg = context.read<Config>().palette['7'];
    final model = context.watch<CollectionModel>();
    final children = [
      Provider<double>.value(
        value: max(ss.height, ss.width) / 1000,
        child: Container(
          height: max(ss.height, ss.width) / 2,
          width: max(ss.height, ss.width) / 2,
          color: bg,
          child: Display(
            key: ValueKey<int>(
              context.watch<ValueNotifier<Selected?>>().value?.rank ?? 0,
            ),
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
        color: bg,
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

MaterialColor createMaterialColor(Color color) {
  final List strengths = <double>[.05];
  final Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

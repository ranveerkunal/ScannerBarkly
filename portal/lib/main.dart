import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  MyApp(this.config);

  @override
  Widget build(BuildContext context) {
    final model = CollectionModel(config.slug);
    return Provider.value(
      value: config,
      child: MaterialApp(
        title: 'ScannerBarkly',
        theme: ThemeData(primarySwatch: createMaterialColor(config.bg)),
        home: ChangeNotifierProvider.value(value: model, child: MyHomePage()),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ValueNotifier<Selected?> selected = ValueNotifier<Selected?>(null);

  @override
  Widget build(BuildContext context) {
    final ss = MediaQuery.of(context).size;
    final scale = min(ss.height, ss.width) / 500;
    final bg = context.read<Config>().bg;
    final model = context.watch<CollectionModel>();
    return Provider<double>.value(
      value: scale,
      child: Scaffold(
        body: ChangeNotifierProvider.value(
          value: selected,
          child: Wrap(children: [
            Container(
              height: ss.height > ss.width ? ss.height - ss.width : ss.height,
              width: ss.height > ss.width ? ss.width : ss.width - ss.height,
              color: bg,
              child: Padding(
                padding: EdgeInsets.all(40 * scale),
                child: Builder(builder: (BuildContext context) {
                  if (context.watch<ValueNotifier<Selected?>>().value == null) {
                    return Container();
                  }
                  return Display();
                }),
              ),
            ),
            Collage(model),
          ]),
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

import 'package:flutter/material.dart';
import 'package:portal/config.dart';
import 'package:portal/selector.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Display extends StatelessWidget {
  final ValueNotifier<bool> showQr = ValueNotifier<bool>(false);
  final double size;

  Display({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selector = context.watch<TileSelector>();
    final rank = selector.rank;
    final asset = context.watch<Map<int, TileAsset>>()[rank]!;
    if (asset.img == null) return Container();
    final scale = context.read<double>();
    return ChangeNotifierProvider<ValueNotifier<bool>>.value(
      value: showQr,
      child: Container(
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
            Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onDoubleTap: () => showQr.value = !showQr.value,
                  child: AnimatedSwitcher(
                    duration: Duration(seconds: 3),
                    child: Image(
                      image: context.watch<ValueNotifier<bool>>().value
                          ? AssetImage('data/qr/$rank.jpg')
                          : asset.img!,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                      height: 420 * scale,
                      width: 420 * scale,
                    ),
                  ),
                );
              },
            ),
            Container(
              height: 40 * scale,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5 * scale),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => launch(asset.config.opensea),
                    child: Image.asset('data/opensea.png'),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: Image.asset('data/wikipedia.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

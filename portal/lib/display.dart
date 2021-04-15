import 'package:flutter/material.dart';
import 'package:portal/tile.dart';
import 'package:provider/provider.dart';

class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ValueNotifier<Selected?>>();
    if (selected.value == null) return Container();
    return Center(
      child: Image(image: selected.value!.img, gaplessPlayback: true),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectionModel extends ChangeNotifier {
  static final client = http.Client();
  Map<int, dynamic> collection = {};

  Map<String, dynamic>? getAsset(int id) =>
      collection[id] == null ? null : collection[id] as Map<String, dynamic>;

  CollectionModel(String slug) {
    Future.wait([0, 50, 100].map(
      (offset) => client.get(
        Uri.https('api.opensea.io', '/api/v1/assets', {
          'offset': '$offset',
          'limit': '50',
          'collection': slug,
        }),
      ),
    )).then(
      (responses) {
        collection = Map.fromEntries(
          responses
              .map((res) => (json.decode(res.body) as Map)['assets'] as List)
              .expand((i) => i)
              .map((asset) => MapEntry(asset['id'] as int, asset)),
        );
        notifyListeners();
      },
    );
  }
}

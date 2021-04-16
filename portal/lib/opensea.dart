import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CollectionModel extends ChangeNotifier {
  static final client = http.Client();
  Map<int, dynamic> collection = {};

  Map<String, dynamic>? getAsset(int id) =>
      collection[id] == null ? null : collection[id] as Map<String, dynamic>;

  Future<List<http.Response>> fetchAssets(String slug) async {
    final List<http.Response> responses = [];
    for (int offset in [0, 50, 100]) {
      print('Fetching offset $offset');
      responses.add(await client.get(
        Uri.https('api.opensea.io', '/api/v1/assets', {
          'offset': '$offset',
          'limit': '50',
          'collection': slug,
        }),
      ));
    }
    return responses;
  }

  CollectionModel(String slug) {
    fetchAssets(slug).then(
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

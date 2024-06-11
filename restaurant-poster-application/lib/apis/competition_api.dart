import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/competition.dart';
import 'package:http/http.dart' as http;

class CompetitonApi {
  static String server =
      '23af-2a02-1810-85ac-2c00-9df0-5ee3-e570-b255.ngrok-free.app';

  static Future<ARCompetition> insertARCompetition(
      ARCompetition ar_competition) async {
    var url = Uri.https(server, '/scanningCompetition');

    debugPrint(ar_competition.name + ar_competition.id);

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'ngrok-skip-browser-warning': 'true',
        'Bypass-Tunnel-Reminder': 'true',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ar_competition),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create competition');
    } else {
      return ARCompetition.fromJson(jsonDecode(response.body));
    }
  }
}

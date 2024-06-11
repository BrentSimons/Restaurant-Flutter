import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/dish.dart';

class RestaurantApi {
  static String server =
      '23af-2a02-1810-85ac-2c00-9df0-5ee3-e570-b255.ngrok-free.app';

  static Future<List<Dish>> fetchArDishes() async {
    var url = Uri.http(server, '/dishes');

    final response = await http.get(url, headers: {
      'ngrok-skip-browser-warning': 'true',
      'Bypass-Tunnel-Reminder': 'true'
    });

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      List<Dish> dishes =
          jsonResponse.take(3).map((d) => Dish.fromJson(d)).toList();
      return dishes;
    } else {
      throw Exception('Failed to load dishes');
    }
  }
}

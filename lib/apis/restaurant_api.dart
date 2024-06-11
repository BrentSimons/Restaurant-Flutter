import 'package:http/http.dart' as http;
import 'package:restaurant/models/order.dart';
import 'package:restaurant/models/review.dart';
import 'dart:convert';
import '../models/dish.dart';

class RestaurantApi {
  static String server = '0.tcp.eu.ngrok.io:13112';

  static Future<List<Dish>> fetchMenu() async {
    var url = Uri.http(server, '/dishes');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((d) => Dish.fromJson(d)).toList();
    } else {
      throw Exception('Failed to load dish');
    }
  }

  // returns all orders
  static Future<List<Order>> fetchOrders() async {
    var url = Uri.http(server, '/orders');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((o) => Order.fromJson(o)).toList();
    } else {
      throw Exception('Failed to load dish');
    }
  }

  // creates a new order [order]
  static Future<Order> createOrder(Order order) async {
    var url = Uri.http(server, '/orders');

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order),
    );
    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }

  // GET reviews
  static Future<List<Review>> fetchReviews() async {
    var url = Uri.http(server, '/reviews');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((review) => Review.fromJson(review)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // POST reviews
  static Future<Review> createReview(Review review) async {
    var url = Uri.http(server, '/reviews');

    final responseGet = await http.get(url);

    List jsonResponse = json.decode(responseGet.body);
    int reviewCount = jsonResponse.length;

    review.id = reviewCount + 1;

    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(review),
    );
    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create review');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:restaurant/pages/menu_list.dart';
import 'package:restaurant/pages/review_list.dart';
import 'package:restaurant/pages/order_list.dart';

void main() => runApp(const RestaurantApp());

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Restaurant App"),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Order'),
                Tab(icon: Icon(Icons.star), text: 'Review'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [MenuListPage(), OrderingPage(), ReviewPage()],
          ),
        ),
      ),
    );
  }
}

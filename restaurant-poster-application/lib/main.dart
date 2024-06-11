import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(const RestaurantPosterApp());
}

class RestaurantPosterApp extends StatelessWidget {
  const RestaurantPosterApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

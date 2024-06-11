import 'package:flutter/material.dart';
import '../widgets/armultipletargets.dart';

class ArMealPage extends StatefulWidget {
  const ArMealPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArMealPageState();
}

class _ArMealPageState extends State<ArMealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Order a meal from the poster!"),
      // ),
      body: Container(
        child: const Center(
          // Here we load the Widget with the AR Meal experience
          child: ArMultipleTargetsWidget()),
          )
      );
  }
}
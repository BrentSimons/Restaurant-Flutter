import 'package:flutter/material.dart';
import 'package:restaurant/apis/restaurant_api.dart';
import 'package:restaurant/models/dish.dart';
import 'package:restaurant/models/order.dart';
import 'package:restaurant/util/util.dart';

class OrderingPage extends StatefulWidget {
  const OrderingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  List<Dish> selectedItems = [];
  List<Dish> availableItems = [];
  String name = '';
  String email = '';
  int totalOrders = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getMenu();
    _getOrders();
  }

  void _getMenu() {
    RestaurantApi.fetchMenu().then((result) {
      setState(() {
        availableItems = result;
      });
    });
  }

  void _getOrders() {
    RestaurantApi.fetchOrders().then((value) {
      setState(() {
        totalOrders = value.length;
      });
    });
  }

  void _showOrderDialog(
      String dishOrderer, String pickupTime, List<Dish> menu) {
    String _formatTime() {
      return pickupTime.substring(0, 16).replaceAll('T', " ");
    }

    String _formatMenu() {
      return "\n${menu.map((dish) => '- ${dish.dishName}').join('\n')}";
    }

    Util.showSimpleDialog(context, "Order Placed",
        'Hello $dishOrderer, your order has been placed successfully, and is ready for pickup at ${_formatTime()}!\nYour order consists of ${_formatMenu()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordering Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select a dish',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200], // Change the background color
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Adjust padding
              ),
              value:
                  selectedItems.isNotEmpty ? selectedItems.last.dishName : null,
              items: availableItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item.dishName,
                  child: Text(item.dishName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    selectedItems.add(_findDish(value));
                  }
                });
              },
            ),
            const SizedBox(height: 5),
            const Text('Selected Items:'),
            Column(
              children: selectedItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Row(
                  children: [
                    Text(item.dishName),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          selectedItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                if (email.isEmpty || name.isEmpty) {
                  Util.showSimpleDialog(context, "Something went wrong!",
                      "Please make sure that your email and name are filled in!");
                  return;
                }

                if (selectedItems.isEmpty) {
                  Util.showSimpleDialog(context, "Something went wrong!",
                      "You must select atleast 1 dish!");
                  return;
                }

                final orderId = totalOrders + 1;
                final orderMappedToIds =
                    selectedItems.map((e) => e.id).toList();

                final Order order = Order(
                    id: orderId,
                    orderDishIds: orderMappedToIds,
                    pickupTime: DateTime.now().add(const Duration(hours: 2)),
                    email: email,
                    fullName: name);

                nameController.clear();
                emailController.clear();

                List<Dish> orderedDishes = List.empty(growable: true);
                for (int orderedId in order.orderDishIds) {
                  for (Dish dish in availableItems) {
                    if (orderedId != dish.id) continue;
                    orderedDishes.add(dish);
                  }
                }

                RestaurantApi.createOrder(order);
                _showOrderDialog(order.fullName,
                    order.pickupTime.toIso8601String(), orderedDishes);

                // now we're gonna clear all the fields
                setState(() {
                  selectedItems.clear();
                  name = "";
                  email = "";
                });
              },
              child: const Text('Submit Order'),
            ),
          ],
        ),
      ),
    );
  }

  // returns a dish based of the passed in [dishName].
  Dish _findDish(String dishName) {
    return availableItems.firstWhere((d) => d.dishName == dishName);
  }
}

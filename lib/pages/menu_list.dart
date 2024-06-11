import 'package:flutter/material.dart';
import 'package:restaurant/util/util.dart';
import '../models/dish.dart';
import '../apis/restaurant_api.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MenuListPageState();
}

class _MenuListPageState extends State {
  List<Dish> dishList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getMenu();
  }

  void _getMenu() {
    RestaurantApi.fetchMenu().then((result) {
      setState(() {
        dishList = result;
        count = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _menuListItems(),
      ),
    );
  }

  void _showDishInfo(Dish? dish) {
    if (dish == null) return;

    String _compileIngredients() {
      return "\n${dish.ingredients.map((ingredient) => "- $ingredient").join('\n')}";
    }

    Util.showSimpleDialog(context, "Dish Info (${dish.dishName})",
        '\n${dish.description}\n${_compileIngredients()}\n\nPrice: ${dish.price}Є',
        image: Image.asset(dish.image,
            width: 285, height: 285, fit: BoxFit.contain));
  }

  ListView _menuListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Image.asset(
              dishList[position].image,
              width: 80,
              height: 90,
              fit: BoxFit.fill,
            ),
            title: Text(
                "${dishList[position].dishName} ${dishList[position].dishName}"),
            subtitle: const Text("Tap for more info"),
            onTap: () {
              _showDishInfo(dishList[position]);
            },
          ),
        );
      },
    );
  }
}

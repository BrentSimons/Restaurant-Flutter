class Dish {
  int id;
  String dishName;
  String description;
  double price;
  List<String> ingredients;
  String image;

  Dish(this.id, this.dishName, this.description, this.price, this.ingredients,
      this.image);

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      json['id'],
      json['dishName'],
      json['description'],
      json['price'].toDouble(),
      List<String>.from(json['ingredients']),
      json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishName': dishName,
      'description': description,
      'price': price,
      'ingredients': ingredients,
      'image': image
    };
  }
}

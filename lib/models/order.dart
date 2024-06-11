class Order {
  final int id;
  final List<int> orderDishIds;
  final DateTime pickupTime;
  final String email;
  final String fullName;

  Order(
      {required this.id,
      required this.orderDishIds,
      required this.pickupTime,
      required this.email,
      required this.fullName});

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<int> orderDishIds = List<int>.from(json['orderDishIds']);
    final String pickupTimeString = json['pickupTime'];

    // Parse the pickup time from the string
    final DateTime pickupTime = DateTime.parse(pickupTimeString);

    final String email = json['email'];
    final String fullName = json['fullName'];

    return Order(
        id: json['id'] as int,
        orderDishIds: orderDishIds,
        pickupTime: pickupTime,
        email: email,
        fullName: fullName);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDishIds': orderDishIds,
      'pickupTime': pickupTime.toIso8601String(),
      'email': email,
      'fullName': fullName,
    };
  }
}

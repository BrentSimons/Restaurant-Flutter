class Review {
  int id;
  String name;
  int rating;
  String description;

  Review({required this.id, required this.name, required this.rating, required this.description});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      name: json['name'],
      rating: json['rating'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'description': description,
      };
}
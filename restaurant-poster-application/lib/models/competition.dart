class ARCompetition {
  String name;
  String id;

  ARCompetition({required this.name, required this.id});

  factory ARCompetition.fromJson(Map<String, dynamic> json) {
    return ARCompetition(name: json['name'], id: json['id']);
  }
}

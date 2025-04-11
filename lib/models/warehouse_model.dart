class Warehouse {
  final int id;
  final String name;
  final String description;
  final String type;

  Warehouse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {'id': id, 'name': name, 'type': type};

    if (description.isNotEmpty) data['description'] = description;

    return data;
  }
}

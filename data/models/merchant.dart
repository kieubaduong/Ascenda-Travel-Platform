import 'dart:convert';

class Merchant {
  int id;
  String name;
  double distance;

  Merchant({
    required this.id,
    required this.name,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      distance: map['distance']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Merchant.fromJson(String source) =>
      Merchant.fromMap(json.decode(source));
}

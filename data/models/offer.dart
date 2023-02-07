import 'dart:convert';

import 'package:intl/intl.dart';

import 'merchant.dart';

class Offer {
  int id;
  String title;
  String description;
  int category;
  List<Merchant> merchants;
  DateTime valid_to;
  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.merchants,
    required this.valid_to,
  });

  void getClosestMerchant() {
    double minDistance = merchants[0].distance;
    int minIndex = 0;
    for (var i = 1; i < merchants.length; i++) {
      if (merchants[i].distance < minDistance) {
        minDistance = merchants[i].distance;
        minIndex = i;
      }
    }
    Merchant closestMerchant = merchants[minIndex];
    merchants = [closestMerchant];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'merchants': merchants.map((x) => x.toMap()).toList(),
      'valid_to': valid_to.toString().substring(0, 10),
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category']?.toInt() ?? 0,
      merchants: List<Merchant>.from(
          map['merchants']?.map((x) => Merchant.fromMap(x))),
      valid_to: DateFormat('y-MM-dd').parse(map['valid_to']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Offer.fromJson(String source) => Offer.fromMap(json.decode(source));
}

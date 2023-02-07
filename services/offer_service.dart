import 'dart:developer';

import 'package:dio/dio.dart';

import '../data/models/offer.dart';
import '../values/string.dart';

class OfferService {
  static final OfferService ins = OfferService._initInstance();

  OfferService._initInstance() {}

  Future<List<Offer>?> getOffersNearBy({
    double lat = 1.313492,
    double lon = 103.860359,
    double rad = 20,
  }) async {
    try {
      Response res =
          await Dio().get("${baseApiUrl}/near_by?lat=$lat&lon=$lon&rad=$rad");
      if (res.statusCode == 200) {
        return res.data["offers"]
            .map<Offer>((e) => Offer.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        log("server error: ${res.statusMessage}");
      }
    } catch (e) {
      log("get offers error: $e");
    }
    return null;
  }
}

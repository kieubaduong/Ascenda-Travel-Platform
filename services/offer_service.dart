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
      return res.data["offers"]
          .map<Offer>((e) => Offer.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      log("get offers error: $e");
    }
    return null;
  }
}

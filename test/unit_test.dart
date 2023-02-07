import 'dart:convert';

import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../data/models/merchant.dart';
import '../data/models/near-by_offers.dart';
import '../data/models/offer.dart';
import '../services/offer_service.dart';

Future<void> main() async {
  List<Offer>? offers = await OfferService.ins.getOffersNearBy();

  group("Offer expired", () {
    test("Checkin date is too far", () {
      DateTime checkinDate = DateTime(2023, 5, 5);
      NearbyOffers nearbyOffers =
          NearbyOffers(offers: offers!, checkinDate: checkinDate);
      String result = nearbyOffers.filterOffers();
      expect(result, "No offer from the third party");
    });

    test("Checkin date is equal to expired date of offer", () {
      offers = [offers![3], offers![4], offers![5]];
      DateTime checkinDate = DateTime(2022, 5, 1);
      NearbyOffers nearbyOffers =
          NearbyOffers(offers: offers!, checkinDate: checkinDate);
      String result = nearbyOffers.filterOffers();
      expect(result, "No offer from the third party");
    });
  });

  group("Filter offer", () {
    test('If only one offer eligible', () {
      offers = [
        Offer(
          category: 1,
          title: "test",
          description: "test",
          id: 1,
          merchants: [Merchant(id: 1, distance: 0.5, name: "Duong Ba Kieu")],
          valid_to: DateTime(2023, 2, 12),
        ),
        Offer(
          category: 1,
          title: "test",
          description: "test",
          id: 1,
          merchants: [Merchant(id: 1, distance: 0.8, name: "Duong Ba Kieu")],
          valid_to: DateTime(2023, 2, 6),
        ),
      ];
      DateTime checkinDate = DateTime(2023, 2, 6);
      NearbyOffers nearbyOffers =
          NearbyOffers(offers: offers!, checkinDate: checkinDate);
      List<Offer> result = jsonDecode(nearbyOffers.filterOffers())
          .map<Offer>((e) => Offer.fromMap(e as Map<String, dynamic>))
          .toList();
      expect(result.length, 1);
    });

    test('If only one type of category offer eligible and have same distance',
        () {
      offers = [
        Offer(
          category: 1,
          title: "test",
          description: "test",
          id: 1,
          merchants: [Merchant(id: 1, distance: 0.5, name: "Duong Ba Kieu")],
          valid_to: DateTime(2023, 2, 12),
        ),
        Offer(
          category: 1,
          title: "test",
          description: "test",
          id: 1,
          merchants: [Merchant(id: 1, distance: 0.5, name: "Duong Ba Kieu")],
          valid_to: DateTime(2023, 2, 15),
        ),
      ];
      DateTime checkinDate = DateTime(2023, 2, 6);
      NearbyOffers nearbyOffers =
          NearbyOffers(offers: offers!, checkinDate: checkinDate);
      List<Offer> result = jsonDecode(nearbyOffers.filterOffers())
          .map<Offer>((e) => Offer.fromMap(e as Map<String, dynamic>))
          .toList();
      expect(result.length, 2);
    });

    test('If input only have one offer', () {
      offers = [
        Offer(
          category: 1,
          title: "test",
          description: "test",
          id: 1,
          merchants: [Merchant(id: 1, distance: 0.5, name: "Duong Ba Kieu")],
          valid_to: DateTime(2023, 2, 12),
        ),
      ];
      DateTime checkinDate = DateTime(2023, 2, 6);
      NearbyOffers nearbyOffers =
          NearbyOffers(offers: offers!, checkinDate: checkinDate);
      List<Offer> result = jsonDecode(nearbyOffers.filterOffers())
          .map<Offer>((e) => Offer.fromMap(e as Map<String, dynamic>))
          .toList();
      expect(result.length, 1);
    });
  });
}

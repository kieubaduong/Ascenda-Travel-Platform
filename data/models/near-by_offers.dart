import 'dart:convert';

import '../enums/category.dart';
import '../../values/constant.dart';
import 'offer.dart';

class NearbyOffers {
  List<Offer> offers;
  DateTime checkinDate;

  NearbyOffers({
    required this.offers,
    required this.checkinDate,
  });

  void filterCategory(
      {required List<Offer> offers,
      required Map<int, Category> filterCategories}) {
    offers
        .removeWhere((offer) => !filterCategories.containsKey(offer.category));
  }

  void validateCheckinDate(List<Offer> offers) {
    offers.removeWhere((offer) {
      DateTime expirationDate =
          checkinDate.add(Duration(days: numberOfExpirationDays));
      return !(offer.valid_to.compareTo(expirationDate) > 0);
    });
  }

  void getClosedOfferInEveryCategory(offersByCategory) {
    offersByCategory.forEach((categoryId, listOffer) {
      double minDistance = listOffer[0].merchants[0].distance;
      int minIndex = 0;
      for (var i = 0; i < listOffer.length; i++) {
        if (minDistance < listOffer[i].merchants[0].distance) {
          minDistance = listOffer[i].merchants[0].distance;
          minIndex = 0;
        }
      }
      listOffer = [listOffer[minIndex]];
    });
  }

  Map<int, List<Offer>> mapEveryOfferByCategoryid(
      {required List<Offer> offers}) {
    Map<int, List<Offer>> offersByCategory = {};
    for (var offer in offers) {
      if (offersByCategory[offer.category] != null) {
        offersByCategory[offer.category]?.add(offer);
      } else {
        offersByCategory[offer.category] = [offer];
      }
    }
    return offersByCategory;
  }

  List<Offer> getTwoClosestOffers(offers) {
    List<Offer> result = [];
    offers.forEach((offer) => offer.getClosestMerchant());
    Map<int, List<Offer>> offersByCategory =
        mapEveryOfferByCategoryid(offers: offers);
    bool onlyOneCategoryEligible = offersByCategory.length == 1;
    if (onlyOneCategoryEligible) {
      offersByCategory.forEach((categoryId, listOffer) {
        listOffer.sort((a, b) =>
            a.merchants[0].distance.compareTo(b.merchants[0].distance));
        if (listOffer.length == 1) {
          result = [listOffer[0]];
        } else {
          result = [listOffer[0], listOffer[1]];
        }
      });
      return result;
    } else {
      getClosedOfferInEveryCategory(offersByCategory);
    }

    List<Offer> filteredOffer = [];
    offersByCategory.forEach((key, value) {
      filteredOffer.add(value[0]);
    });

    filteredOffer.sort(
        (a, b) => a.merchants[0].distance.compareTo(b.merchants[0].distance));
    if (filteredOffer.length < 2) {
      result = [filteredOffer[0]];
    } else {
      result = [filteredOffer[0], filteredOffer[1]];
    }
    return result;
  }

  String filterOffers({
    Map<int, Category> filterCategories = const {
      1: Category.Resturant,
      2: Category.Retail,
      4: Category.Activity,
    },
  }) {
    List<Offer> filteredOffer = List.from(offers);
    filterCategory(
      offers: filteredOffer,
      filterCategories: filterCategories,
    );
    validateCheckinDate(filteredOffer);
    if (filteredOffer.length == 0) {
      return "No offer from the third party";
    }
    filteredOffer = getTwoClosestOffers(filteredOffer);
    return jsonEncode(filteredOffer.map((e) => e.toMap()).toList());
  }
}

import 'dart:io';

import 'data/models/near-by_offers.dart';
import 'data/models/offer.dart';
import 'services/offer_service.dart';

DateTime readUserInput() {
  print("Enter your checkin date");
  int? year, month, day;
  print("Enter year");
  year = int.tryParse(stdin.readLineSync()!);
  while (year == null || year <= 0) {
    print("Ivalid year, please retype");
    year = int.tryParse(stdin.readLineSync()!);
  }
  print("Enter month");
  month = int.tryParse(stdin.readLineSync()!);
  while (month == null || month < 1 || month > 12) {
    print("Ivalid month, please retype");
    month = int.tryParse(stdin.readLineSync()!);
  }
  print("Enter day");
  day = int.tryParse(stdin.readLineSync()!);
  while (day == null || day < 1 || day > 31) {
    print("Ivalid day, please retype");
    day = int.tryParse(stdin.readLineSync()!);
  }
  return DateTime(year, month, day);
}

Future<void> main() async {
  List<Offer>? offers = await OfferService.ins.getOffersNearBy();
  if (offers == null) {
    print("Something went wrong");
    return;
  }
  if (offers == []) {
    print("No offer from the third party");
    return;
  }

  DateTime checkinDate = readUserInput();

  NearbyOffers nearbyOffers =
      NearbyOffers(offers: offers, checkinDate: checkinDate);
  print(nearbyOffers.filterOffers());
}

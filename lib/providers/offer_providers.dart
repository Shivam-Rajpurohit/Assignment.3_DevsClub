import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/offer.dart';
import '../repositories/offer_repository.dart';
import '../features/auth/auth_provider.dart';

final offerRepositoryProvider = Provider((ref) => OfferRepository());

final buyerOffersProvider = StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(offerRepositoryProvider).watchBuyerOffers(user.uid);
});

final sellerOffersProvider = StreamProvider<List<Offer>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(offerRepositoryProvider).watchSellerOffers(user.uid);
});
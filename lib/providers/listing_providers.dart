import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing.dart';
import '../repositories/listing_repository.dart';
import '../features/auth/auth_provider.dart';

final listingRepositoryProvider = Provider((ref) => ListingRepository());

final activeListingsProvider = StreamProvider<List<Listing>>((ref) {
  return ref.watch(listingRepositoryProvider).watchActiveListings();
});

final sellerListingsProvider = StreamProvider<List<Listing>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(listingRepositoryProvider).watchSellerListings(user.uid);
});
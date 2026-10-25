import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class ListingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createListing(Listing listing) async {
    await _db.collection('listings').add(listing.toMap());
  }

  Stream<List<Listing>> watchActiveListings() {
    return _db
        .collection('listings')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList());
  }

  Stream<List<Listing>> watchSellerListings(String sellerId) {
    return _db
        .collection('listings')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Listing.fromFirestore(doc)).toList());
  }

  Future<void> updateListingStatus(String listingId, String status) async {
    await _db.collection('listings').doc(listingId).update({'status': status});
  }

  Future<void> deleteListing(String listingId) async {
    await _db.collection('listings').doc(listingId).delete();
  }
}
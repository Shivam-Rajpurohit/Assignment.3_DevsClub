import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer.dart';

class OfferRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOffer(Offer offer) async {
    await _db.collection('offers').add(offer.toMap());
  }

  Stream<List<Offer>> watchBuyerOffers(String buyerId) {
    return _db
        .collection('offers')
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList());
  }

  Stream<List<Offer>> watchSellerOffers(String sellerId) {
    return _db
        .collection('offers')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Offer.fromFirestore(doc)).toList());
  }

  Future<void> updateOfferStatus(String offerId, String status) async {
    await _db.collection('offers').doc(offerId).update({'status': status});
  }
}
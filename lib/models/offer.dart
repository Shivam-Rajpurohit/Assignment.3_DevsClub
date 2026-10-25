import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String listingId;
  final String buyerId;
  final String sellerId;
  final String listingTitle;
  final double proposedPrice;
  final String meetingSpot;
  final String status;

  Offer({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    required this.listingTitle,
    required this.proposedPrice,
    required this.meetingSpot,
    required this.status,
  });

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Offer(
      id: doc.id,
      listingId: data['listingId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      listingTitle: data['listingTitle'] ?? '',
      proposedPrice: (data['proposedPrice'] ?? 0).toDouble(),
      meetingSpot: data['meetingSpot'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'listingTitle': listingTitle,
      'proposedPrice': proposedPrice,
      'meetingSpot': meetingSpot,
      'status': status,
    };
  }
}
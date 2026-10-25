import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final String condition;
  final String department;
  final String semester;
  final String status;
  final DateTime createdAt;

  Listing({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.department,
    required this.semester,
    required this.status,
    required this.createdAt,
  });

  factory Listing.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Listing(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      condition: data['condition'] ?? 'Good',
      department: data['department'] ?? '',
      semester: data['semester'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'title': title,
      'description': description,
      'price': price,
      'condition': condition,
      'department': department,
      'semester': semester,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
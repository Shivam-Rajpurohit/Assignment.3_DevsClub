import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_providers.dart';
import '../../providers/offer_providers.dart';
import 'create_listing_screen.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(sellerListingsProvider);
    final offers = ref.watch(sellerOffersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Dashboard')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateListingScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('My Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          listings.when(
            data: (data) => Column(
              children: data.map((l) => ListTile(
                title: Text(l.title),
                subtitle: Text('\$${l.price} - ${l.status}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => ref.read(listingRepositoryProvider).deleteListing(l.id),
                ),
              )).toList(),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
          const Divider(height: 40),
          const Text('Incoming Offers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          offers.when(
            data: (data) => Column(
              children: data.map((o) => ListTile(
                title: Text('Offer: \$${o.proposedPrice} for ${o.listingTitle}'),
                subtitle: Text('Status: ${o.status}'),
                trailing: o.status == 'pending' ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => ref.read(offerRepositoryProvider).updateOfferStatus(o.id, 'accepted')),
                    IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => ref.read(offerRepositoryProvider).updateOfferStatus(o.id, 'rejected')),
                  ],
                ) : null,
              )).toList(),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}
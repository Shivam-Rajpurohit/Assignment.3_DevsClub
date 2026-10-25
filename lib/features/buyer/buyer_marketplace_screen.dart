import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_providers.dart';
import '../../providers/offer_providers.dart';
import '../../models/offer.dart';
import '../auth/auth_provider.dart';

class BuyerMarketplaceScreen extends ConsumerWidget {
  const BuyerMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(activeListingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Campus Marketplace')),
      body: listings.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final l = data[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(l.title),
                subtitle: Text('\$${l.price} • ${l.condition}'),
                trailing: ElevatedButton(
                  onPressed: () => _showOfferDialog(context, ref, l),
                  child: const Text('Make Offer'),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showOfferDialog(BuildContext context, WidgetRef ref, dynamic listing) {
    final priceController = TextEditingController(text: listing.price.toString());
    final user = ref.read(authStateProvider).value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Offer for ${listing.title}'),
        content: TextField(
          controller: priceController,
          decoration: const InputDecoration(labelText: 'Your Price'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (user == null) return;
              final offer = Offer(
                id: '',
                listingId: listing.id,
                buyerId: user.uid,
                sellerId: listing.sellerId,
                listingTitle: listing.title,
                proposedPrice: double.tryParse(priceController.text) ?? listing.price,
                meetingSpot: 'Campus Library',
                status: 'pending',
              );
              ref.read(offerRepositoryProvider).createOffer(offer);
              Navigator.pop(context);
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
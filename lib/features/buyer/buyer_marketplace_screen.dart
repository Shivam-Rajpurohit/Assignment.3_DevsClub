import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/listing_providers.dart';
import '../../providers/offer_providers.dart';
import '../../providers/theme_provider.dart';
import '../../models/offer.dart';
import '../auth/auth_provider.dart';

class BuyerMarketplaceScreen extends ConsumerWidget {
  const BuyerMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(activeListingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Marketplace', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final currentTheme = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
              currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: listings.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No items yet.\nBe the first to sell!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72, // Adjusted to fit the gradient button
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final l = data[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image, color: Theme.of(context).colorScheme.primary.withOpacity(0.5), size: 35),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '\$${l.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),

                      // THIS IS THE CORRECT PLACE FOR THE GRADIENT BUTTON
                      InkWell(
                        onTap: () => _showOfferDialog(context, ref, l),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Make Offer',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        },
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Make an Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Item: ${listing.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Your Price (\$)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
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
            child: const Text('Send Offer'),
          ),
        ],
      ),
    );
  }
}
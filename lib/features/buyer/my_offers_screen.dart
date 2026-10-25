import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/offer_providers.dart';

class MyOffersScreen extends ConsumerWidget {
  const MyOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(buyerOffersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Offers')),
      body: offers.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final o = data[index];
            return ListTile(
              title: Text(o.listingTitle),
              subtitle: Text('Offered: \$${o.proposedPrice} • Status: ${o.status}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
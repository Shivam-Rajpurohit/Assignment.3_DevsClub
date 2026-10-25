import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/listing.dart';
import '../../providers/listing_providers.dart';
import '../auth/auth_provider.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _condition = 'Good';

  void _submit() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final listing = Listing(
      id: '',
      sellerId: user.uid,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0.0,
      condition: _condition,
      department: 'General',
      semester: 'Any',
      status: 'active',
      createdAt: DateTime.now(),
    );

    await ref.read(listingRepositoryProvider).createListing(listing);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text('Post to Marketplace')),
          ],
        ),
      ),
    );
  }
}
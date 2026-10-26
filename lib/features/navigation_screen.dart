import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/auth_provider.dart';
import 'auth/login_screen.dart';
import 'seller/seller_dashboard_screen.dart';
import 'buyer/buyer_marketplace_screen.dart';
import 'buyer/my_offers_screen.dart';
import 'settings/settings_screen.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  int _index = 0;

  final List<Widget> _screens = [
    const BuyerMarketplaceScreen(),
    const MyOffersScreen(),
    const SellerDashboardScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.store), label: 'Market'),
          NavigationDestination(icon: Icon(Icons.local_offer), label: 'My Offers'),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Selling'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) => user != null ? const NavigationScreen() : LoginScreen(),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
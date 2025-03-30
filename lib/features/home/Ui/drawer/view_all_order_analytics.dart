import 'package:flutter/material.dart';

class InvoiceSectionView extends StatelessWidget {
  const InvoiceSectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Invoice Payments')),
      body: Center(
        child: Text(
          'Invoice Section View Content',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class FullClientsView extends StatelessWidget {
  const FullClientsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Clients')),
      body: Center(
        child: Text(
          'Full Clients View Content',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

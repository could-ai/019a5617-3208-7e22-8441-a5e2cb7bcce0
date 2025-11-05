import 'package:flutter/material.dart';
import 'package:couldai_user_app/models.dart';

class TransactionScreen extends StatefulWidget {
  final String userName;

  const TransactionScreen({super.key, required this.userName});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Transaction> _transactions = [];

  @override
  Widget build(BuildContext context) {
    // In a real app, you would filter a global list of transactions
    // final userTransactions = _allTransactions.where((tx) => tx.userName == widget.userName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}\'s Transactions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _transactions.isEmpty
          ? const Center(
              child: Text('No transactions yet. Tap + to add one.'),
            )
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(transaction.id.toString())),
                    title: Text('SR: ${transaction.amountSR} (${transaction.typeSR}) | PKR: ${transaction.amountPKR} (${transaction.typePKR})'),
                    subtitle: Text(transaction.remarks),
                    trailing: Text(
                      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement navigation to an "Add Transaction" screen.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add transaction functionality coming soon!')),
          );
        },
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }
}

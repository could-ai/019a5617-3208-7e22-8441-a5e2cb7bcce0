import 'package:flutter/material.dart';
import 'package:couldai_user_app/models.dart';
import './add_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  final String userName;

  const TransactionScreen({super.key, required this.userName});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<Transaction> _transactions = [];
  double _balanceSR = 0.0;
  double _balancePKR = 0.0;

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.add(transaction);
      
      // Update balances: Debit adds, Credit subtracts
      if (transaction.typeSR == 'Debit') {
        _balanceSR += transaction.amountSR;
      } else {
        _balanceSR -= transaction.amountSR;
      }
      
      if (transaction.typePKR == 'Debit') {
        _balancePKR += transaction.amountPKR;
      } else {
        _balancePKR -= transaction.amountPKR;
      }

      // TODO: Create automatic counter-transaction for Sajid Khan
      // If user is NOT Sajid Khan, create opposite transaction for him
      if (widget.userName != 'Sajid Khan') {
        _createSajidKhanTransaction(transaction);
      }
    });
  }

  void _createSajidKhanTransaction(Transaction originalTransaction) {
    // This creates the opposite transaction for Sajid Khan
    // If user debits, Sajid Khan gets credited (and vice versa)
    final sajidTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch + 1,
      date: originalTransaction.date,
      giver: originalTransaction.giver,
      amountSR: originalTransaction.amountSR,
      typeSR: originalTransaction.typeSR == 'Debit' ? 'Credit' : 'Debit',
      receiver: originalTransaction.receiver,
      amountPKR: originalTransaction.amountPKR,
      typePKR: originalTransaction.typePKR == 'Debit' ? 'Credit' : 'Debit',
      remarks: '${originalTransaction.remarks} (Auto from ${widget.userName})',
      userName: 'Sajid Khan',
    );
    
    // TODO: In a real app, this would be saved to a global transaction list
    // For now, we're just creating the object but not storing it globally
    // This will be implemented when we add proper state management
  }

  @override
  Widget build(BuildContext context) {
    // Sort transactions by date (newest first)
    final sortedTransactions = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}\'s Transactions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Excel export coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Current Balance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('SR Balance', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            _balanceSR.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _balanceSR >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const VerticalDivider(),
                      Column(
                        children: [
                          const Text('PKR Balance', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            _balancePKR.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _balancePKR >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Transaction List
          Expanded(
            child: sortedTransactions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No transactions yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first transaction.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: sortedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = sortedTransactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '${transaction.giver} → ${transaction.receiver}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('SR Amount:'),
                                          Text(
                                            '${transaction.amountSR.toStringAsFixed(2)} (${transaction.typeSR})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: transaction.typeSR == 'Debit'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('PKR Amount:'),
                                          Text(
                                            '${transaction.amountPKR.toStringAsFixed(2)} (${transaction.typePKR})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: transaction.typePKR == 'Debit'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (transaction.remarks.isNotEmpty) ..[
                                    const SizedBox(height: 12),
                                    const Text('Remarks:'),
                                    Text(
                                      transaction.remarks,
                                      style: const TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                userName: widget.userName,
                onAddTransaction: _addTransaction,
              ),
            ),
          );
        },
        tooltip: 'Add Transaction',
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }
}
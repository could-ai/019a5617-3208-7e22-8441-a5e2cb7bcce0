import 'package:flutter/material.dart';
import './transaction_screen.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  final List<String> users = const [
    'Sajid Khan',
    'Zakir Sany',
    'Abdul Ali',
    'Usman Jellah',
    'Laiq Zameen',
    'Irshad Khan',
    'Sultanat Khan',
    'Iftikhar Khan',
    'Placeholder User',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: CircleAvatar(
                child: Text(user.isNotEmpty ? user[0] : 'U'),
              ),
              title: Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionScreen(userName: user),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

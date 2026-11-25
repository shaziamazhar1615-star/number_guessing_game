import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
      ),
      body: FutureBuilder(
        future: DatabaseHelper().getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load history'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Game History Yet!'),
            );
          }

          final history = snapshot.data!;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final game = history[index];

              return ListTile(
                leading: const Icon(Icons.emoji_events),
                title: Text(
                  'Winning Number: ${game['number']}',
                ),
                subtitle: Text(
                  'Attempts: ${game['attempts']}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}